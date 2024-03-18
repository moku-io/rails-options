module Rails
  module OptionsConfig
    class Engine < ::Rails::Engine
      config.options = ActiveSupport::OrderedOptions.new

      config.options.roots = ['config']
      config.options.paths = ['options{,.*}.{yml,yaml}{.enc,}', 'options/**/*.{yml,yaml}{.enc,}']
      config.options.raise_on_override = false
    end
  end
end
