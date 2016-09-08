require 'base64'
require 'json'
require 'line/file'
require 'line/message'
require 'line/operation'
require 'line/user'
require 'net/http'
require 'openssl'

module Line
  class Bot
    attr_accessor :channel_id, :channel_secret, :channel_mid
    attr_accessor :proxy

    def initialize(hash = {}, &block)
      hash.each { |k, v| send(:"#{k}=", v) }
      block[self] if block
    end

    def validate_request(signature, body)
      return false unless signature
      hash = OpenSSL::HMAC::digest(
        OpenSSL::Digest::SHA256.new,
        @channel_secret,
        body
      )
      signature == Base64.strict_encode64(hash)
    end

    def parse_request(body)
      JSON.parse(body)['result'].map do |event|
        case event['eventType']
        when '138311609000106303'
          yield_message_object(event['content'])
        when '138311609100106403'
          yield_operation_object(event['content'])
        end
      end
    end

    def send_message(mids, msg)
      post('/v1/events',
        'to' => [mids].flatten,
        'toChannel' => 1383378250,
        'eventType' => '138311608800106203',
        'content' => msg.to_h
      )
    end

    def send_messages(mids, msgs)
      post('/v1/events',
        'to' => [mids].flatten,
        'toChannel' => 1383378250,
        'eventType' => '140177271400161403',
        'content' => { 'messages' => msgs.map(&:to_h) }
      )
    end

    def get_content(id)
      get "/v1/bot/message/#{id}/content" do |res|
        yield_file_object(res)
      end
    end

    def get_preview(id)
      get "/v1/bot/message/#{id}/content/preview" do |res|
        yield_file_object(res)
      end
    end

    def get_user(mid)
      get_users([mid]).first
    end

    def get_users(mids)
      get "/v1/profiles?mids=#{mids.join(',')}" do |res|
        JSON.parse(res.body)['contacts'].map do |attrs|
          Line::User.new_with(attrs)
        end
      end
    end

    private

    def get(endpoint, &block)
      req = Net::HTTP::Get.new(endpoint, headers_of_get)
      res = https.start { |h| h.request(req) }
      res.value
      block[res]
    end

    def post(endpoint, body)
      req = Net::HTTP::Post.new(endpoint, headers_of_post)
      res = https.start { |h| h.request(req, body.to_json) }
      res.value
    end

    def https
      klass = if @proxy
        uri = URI.parse(@proxy)
        Net::HTTP::Proxy(uri.host, uri.port, uri.user, uri.password)
      else
        Net::HTTP
      end
      klass.new('trialbot-api.line.me', 443).tap { |h| h.use_ssl = true }
    end

    def headers_of_get
      {
        'X-Line-ChannelID' => @channel_id.to_s,
        'X-Line-ChannelSecret' => @channel_secret,
        'X-Line-Trusted-User-With-ACL' => @channel_mid
      }
    end

    def headers_of_post
      headers_of_get.merge(
        'Content-Type' => 'application/json; charset=UTF-8'
      )
    end

    def yield_message_object(attrs)
      klass = Line::Message::Base.subclasses.find do |c|
        c::CONTENT_TYPE == attrs['contentType']
      end
      klass.new_with(attrs)
    end

    def yield_operation_object(attrs)
      klass = Line::Operation::Base.subclasses.find do |c|
        c::OP_TYPE == attrs['opType']
      end
      klass.new_with(attrs)
    end

    def yield_file_object(res)
      name = res['Content-Disposition'][/filename="(.+)"/, 1]
      Line::File.new(name, res.body)
    end
  end
end
