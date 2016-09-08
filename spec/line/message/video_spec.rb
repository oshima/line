describe Line::Message::Video do
  let(:args) do
    [
      'http://example.com/original.mp4',
      'http://example.com/preview.jpg'
    ]
  end

  let(:attrs) do
    {
      "toType" => 1,
      "createdTime" => 1471710813000,
      "from" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "location" => nil,
      "id" => "1111111111111",
      "to" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "text" => "",
      "contentMetadata" => {
        "AT_RECV_MODE" => "2",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 3,
      "seq" => nil
    }
  end

  let(:sendable) { Line::Message::Video.new(*args.deep_dup) }

  let(:received) { Line::Message::Video.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    context 'in the case of a sendable message' do
      it 'returns the correct value' do
        expect(sendable.id).to be_nil
        expect(sendable.from).to be_nil
        expect(sendable.to).to be_nil
        expect(sendable.created_at).to be_nil
        expect(sendable.content_url).to eq args[0]
        expect(sendable.preview_url).to eq args[1]
      end
    end

    context 'in the case of a received message' do
      it 'returns the correct value' do
        expect(received.id).to eq attrs['id'].to_i
        expect(received.from).to eq attrs['from']
        expect(received.to).to eq attrs['to']
        expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
        expect(received.content_url).to be_nil
        expect(received.preview_url).to be_nil
      end
    end
  end

  describe '#to_h' do
    context 'in the case of a sendable message' do
      it 'returns a hash containing the required entries' do
        hash = {
          'contentType' => 3,
          'toType' => 1,
          'originalContentUrl' => args[0],
          'previewImageUrl' => args[1]
        }
        expect(sendable.to_h).to eq hash
      end
    end

    context 'in the case of a received message' do
      it 'returns the received hash' do
        expect(received.to_h).to eq attrs
      end
    end
  end

  describe '#inspect' do
    context 'in the case of a sendable message' do
      it 'returns a string containing no id' do
        str = '#<Line::Message::Video id=nil>'
        expect(sendable.inspect).to eq str
      end
    end

    context 'in the case of a received message' do
      it 'returns a string containing the id' do
        str = "#<Line::Message::Video id=#{attrs['id'].to_i.inspect}>"
        expect(received.inspect).to eq str
      end
    end
  end
end
