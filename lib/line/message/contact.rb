require 'line/message/base'

module Line
  module Message
    class Contact < Line::Message::Base
      CONTENT_TYPE = 10

      attr_reader :mid, 'contentMetadata.mid'
      attr_reader :display_name, 'contentMetadata.displayName'
    end
  end
end
