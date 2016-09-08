require 'line/message/base'

module Line
  module Message
    class Sticker < Line::Message::Base
      CONTENT_TYPE = 8

      attr_reader :stkid, 'contentMetadata.STKID', -> s { s.to_i }
      attr_reader :stkpkgid, 'contentMetadata.STKPKGID', -> s { s.to_i }
      attr_reader :stkver, 'contentMetadata.STKVER', -> s { s.to_i }
      attr_reader :stktxt, 'contentMetadata.STKTXT'

      def initialize(stkid, stkpkgid, stkver = nil)
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'contentMetadata' => {
            'STKID' => stkid.to_s,
            'STKPKGID' => stkpkgid.to_s
          }
        }
        @attrs['contentMetadata']['STKVER'] = stkver.to_s if stkver
      end
    end
  end
end
