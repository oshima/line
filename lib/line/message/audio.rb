require 'line/message/base'

module Line
  module Message
    class Audio < Line::Message::Base
      CONTENT_TYPE = 4

      attr_reader :content_url, 'originalContentUrl'
      attr_reader :audlen, 'contentMetadata.AUDLEN', -> s { s.to_i }

      def initialize(content_url, audlen)
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'originalContentUrl' => content_url,
          'contentMetadata' => { 'AUDLEN' => audlen.to_s }
        }
      end
    end
  end
end
