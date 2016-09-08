require 'json'
require 'line/message/base'

module Line
  module Message
    class RichMessage < Line::Message::Base
      CONTENT_TYPE = 12

      attr_reader :image_url, 'contentMetadata.DOWNLOAD_URL'
      attr_reader :alt_text, 'contentMetadata.ALT_TEXT'
      attr_reader :markup, 'contentMetadata.MARKUP_JSON'

      def initialize(image_url, image_area, alt_text = '')
        @attrs = {
          'contentType' => CONTENT_TYPE,
          'toType' => 1,
          'contentMetadata' => {
            'DOWNLOAD_URL' => image_url,
            'SPEC_REV' => '1',
            'ALT_TEXT' => alt_text,
            'MARKUP_JSON' => initial_markup(image_area)
          }
        }
      end

      def add_web_action(link_url, touch_areas, alt_text = '')
        action = {
          'type' => 'web',
          'text' => alt_text,
          'params' => {
            'linkUri' => link_url
          }
        }
        add_action(action, touch_areas)
      end

      def add_send_message_action(text, touch_areas, alt_text = '')

        action = {
          'type' => 'sendMessage',
          'text' => alt_text,
          'params' => {
            'text' => text
          }
        }
        add_action(action, touch_areas)
      end

      def image_area
        markup['images']['image1'].values
      end

      def to_h
        @attrs.merge(
          'contentMetadata' => @attrs['contentMetadata'].merge(
            'MARKUP_JSON' => markup.to_json
          )
        )
      end

      private

      def initial_markup(image_area)
        {
          'canvas' => {
            'width' => image_area[2],
            'height' => image_area[3],
            'initialScene' => 'scene1'
          },
          'images' => {
            'image1' => {
              'x' => image_area[0],
              'y' => image_area[1],
              'w' => image_area[2],
              'h' => image_area[3]
            }
          },
          'actions' => {},
          'scenes' => {
            'scene1' => {
              'draws' => [
                {
                  'image' => 'image1',
                  'x' => image_area[0],
                  'y' => image_area[1],
                  'w' => image_area[2],
                  'h' => image_area[3]
                }
              ],
              'listeners' => []
            }
          }
        }
      end

      def add_action(action, touch_areas)
        name = "action#{markup['actions'].size + 1}"
        markup['actions'].merge!(name => action)
        touch_areas.flatten.each_slice(4) do |touch_area|
          add_touch_listener(name, touch_area)
        end
      end

      def add_touch_listener(action_name, touch_area)
        markup['scenes']['scene1']['listeners'].push(
          'type' => 'touch',
          'params' => touch_area,
          'action' => action_name
        )
      end
    end
  end
end
