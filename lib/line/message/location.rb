require 'line/message/base'

module Line
  module Message
    class Location < Line::Message::Base
      CONTENT_TYPE = 7

      attr_reader :title, 'location.title'
      attr_reader :latitude, 'location.latitude'
      attr_reader :longitude, 'location.longitude'
      attr_reader :address, 'location.address'

      def initialize(title, latitude, longitude, address = nil)
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'text' => title,
          'location' => {
            'title' => title,
            'latitude' => latitude,
            'longitude' => longitude
          }
        }
        @attrs['location']['address'] = address if address
      end
    end
  end
end
