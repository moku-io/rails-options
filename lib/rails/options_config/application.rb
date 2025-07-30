module Rails
  class Application
    def options env=nil
      if env.nil? || env.to_sym == Rails.env.to_sym
        @options ||= OptionsConfig.parse_options self, Rails.env.to_sym
      else
        OptionsConfig.parse_options self, env.to_sym
      end
    end
  end
end
