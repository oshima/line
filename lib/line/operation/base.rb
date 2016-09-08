require 'line/base'

module Line
  module Operation
    class Base < Line::Base
      attr_reader :revision, 'revision'
      attr_reader :from, 'params', -> a { a[0] }

      def inspect
        "#<#{self.class} revision=#{revision.inspect}>"
      end
    end
  end
end
