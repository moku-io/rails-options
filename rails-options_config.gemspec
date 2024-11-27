require_relative 'lib/rails/options_config/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-options_config'
  spec.version = Rails::OptionsConfig::VERSION
  spec.authors = ['Moku S.r.l.', 'Riccardo Agatea']
  spec.email = ['info@moku.io']
  spec.license = 'MIT'

  spec.summary = 'A uniform interface to multiple option YAML files.'
  spec.description = 'As a project\'s size increases, its credentials file tends to become unmanageable. With Rails ' \
                     'Options Config you can split the credentials into smaller separate YAML files.'
  spec.homepage = 'https://github.com/moku-io/rails-options'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moku-io/rails-options'
  spec.metadata['changelog_uri'] = 'https://github.com/moku-io/rails-options/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir File.expand_path(__dir__) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'railties', '>= 7.0'
  spec.add_dependency 'therefore'
end
