require 'line/message/base'

module Line
  module Message
    class Text < Line::Message::Base
      CONTENT_TYPE = 1

      attr_reader :text, 'text'

      def initialize(text)
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'text' => text
        }
      end
    end
  end
end
