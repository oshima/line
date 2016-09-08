require 'line/base'

module Line
  class User < Line::Base
    attr_reader :mid, 'mid'
    attr_reader :display_name, 'displayName'
    attr_reader :picture_url, 'pictureUrl'
    attr_reader :status_message, 'statusMessage'

    def inspect
      "#<#{self.class} mid=#{mid.inspect}>"
    end
  end
end
