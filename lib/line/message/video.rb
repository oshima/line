require 'line/message/base'

module Line
  module Message
    class Video < Line::Message::Base
      CONTENT_TYPE = 3

      attr_reader :content_url, 'originalContentUrl'
      attr_reader :preview_url, 'previewImageUrl'

      def initialize(content_url, preview_url)
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'originalContentUrl' => content_url,
          'previewImageUrl' => preview_url
        }
      end
    end
  end
end
