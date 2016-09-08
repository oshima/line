require 'line/base'

module Line
  module Message
    class Base < Line::Base
      attr_reader :id, 'id', -> s { s.to_i }
      attr_reader :from, 'from'
      attr_reader :to, 'to'
      attr_reader :created_at, 'createdTime', -> i { Time.at(i / 1000) }

      def inspect
        "#<#{self.class} id=#{id.inspect}>"
      end
    end
  end
end
