module Rails
  class Application
    def options env=nil
      if env.nil?
        @options ||= OptionsConfig.parse_options self, Rails.env.to_sym
      else
        OptionsConfig.parse_options self, env.to_sym
      end
    end
  end
end
