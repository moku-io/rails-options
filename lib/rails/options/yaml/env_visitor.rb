module Rails
  module Options
    class EnvVisitor < Psych::Visitors::ToRuby
      def accept target
        if !target.tag.nil? && target.tag.start_with?('!env/')
          ENV[target.tag.delete_prefix('!env/')]
        else
          super
        end
      end
    end
  end
end
