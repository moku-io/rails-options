require_relative 'yaml/env_visitor'
require_relative 'key_override_error'

module Rails
  class Application
    def options
      @options ||= begin
                     yaml_visitor = OptionsConfig::EnvVisitor.create symbolize_names: true
                     Array(config.options.roots)
                       .flat_map do |root|
                         Dir
                           .glob(Array(config.options.paths), base: root)
                           .map do |path|
                             path.match %r{^(?<filename>.*?)(?<env>\..*?)?(?<extension>\.ya?ml)(?<enc>\.enc)?$} do |md|
                               full_path = Pathname(root).join(path)
                               encrypted = md[:enc].present?
                               content = if encrypted
                                           yaml_visitor.accept YAML.parse(encrypted(full_path).read)
                                         else
                                           yaml_visitor.accept YAML.parse_file(full_path)
                                         end

                               {
                                 path:      full_path,
                                 filename:  md[:filename],
                                 content:   content,
                                 encrypted: encrypted
                               }
                                 .tap do |hash|
                                   hash[:environment] = md[:env].delete_prefix('.').to_sym if md[:env].present?
                                 end
                             end
                           end
                       end
                       .group_by { |file| file[:filename] }
                       .map do |_, files|
                         # Specifics overwrite bases, and encrypted overwrite cleartexts for each.
                         bases = files
                                   .reject { |file| file.key? :environment }
                                   .sort_by { |file| file[:encrypted] ? 1 : 0 }
                         specifics = files
                                       .filter { |file| file[:environment] == Rails.env.to_sym }
                                       .sort_by { |file| file[:encrypted] ? 1 : 0 }

                         (bases + specifics)
                           .reduce({}) { |acc, override| acc.deep_merge override[:content] }
                       end
                       .then do |hashes|
                         if config.options.raise_on_override
                           hashes.reduce credentials.config do |acc, hash|
                             acc.deep_merge hash do |key, value1, value2|
                               raise Options::KeyOverrideError,
                                     'Key override while loading options: ' \
                                     "trying to set `#{key}' to #{value2.inspect}:#{value2.class}, " \
                                     "but it is already set to #{value1.inspect}:#{value1.class}"
                             end
                           end
                         else
                           hashes.reduce(credentials.config, &:deep_merge)
                         end
                       end
                       .then do |hash|
                         deep_transform = proc do |value|
                           if value.is_a? Hash
                             ActiveSupport::OrderedOptions[value.transform_values(&deep_transform)]
                           else
                             value
                           end
                         end
                         deep_transform.call hash
                       end
                   end
    end
  end
end
