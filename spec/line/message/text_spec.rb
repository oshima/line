describe Line::Message::Text do
  let(:attrs) do
    {
      "toType" => 1,
      "createdTime" => 1471710813000,
      "from" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "location" => nil,
      "id" => "1111111111111",
      "to" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "text" => "hello, bot",
      "contentMetadata" => {
        "AT_RECV_MODE" => "2",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 1,
      "seq" => nil
    }
  end

  let(:sendable) { Line::Message::Text.new('hello') }

  let(:received) { Line::Message::Text.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    context 'in the case of a sendable message' do
      it 'returns the correct value' do
        expect(sendable.id).to be_nil
        expect(sendable.from).to be_nil
        expect(sendable.to).to be_nil
        expect(sendable.created_at).to be_nil
        expect(sendable.text).to eq 'hello'
      end
    end

    context 'in the case of a received message' do
      it 'returns the correct value' do
        expect(received.id).to eq attrs['id'].to_i
        expect(received.from).to eq attrs['from']
        expect(received.to).to eq attrs['to']
        expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
        expect(received.text).to eq attrs['text']
      end
    end
  end

  describe '#to_h' do
    context 'in the case of a sendable message' do
      it 'returns a hash containing the required entries' do
        hash = {
          'contentType' => 1,
          'toType' => 1,
          'text' => 'hello'
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
        str = '#<Line::Message::Text id=nil>'
        expect(sendable.inspect).to eq str
      end
    end

    context 'in the case of a received message' do
      it 'returns a string containing the id' do
        str = "#<Line::Message::Text id=#{attrs['id'].to_i.inspect}>"
        expect(received.inspect).to eq str
      end
    end
  end
end
