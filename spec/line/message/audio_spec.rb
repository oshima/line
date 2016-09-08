describe Line::Message::Audio do
  let(:args) { ['http://example.com/original.m4a', 10000] }

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
        "OBS_POP" => "b",
        "AT_RECV_MODE" => "2",
        "AUDLEN" => "20000",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 4,
      "seq" => nil
    }
  end

  let(:sendable) { Line::Message::Audio.new(*args.deep_dup) }

  let(:received) { Line::Message::Audio.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    context 'in the case of a sendable message' do
      it 'returns the correct value' do
        expect(sendable.id).to be_nil
        expect(sendable.from).to be_nil
        expect(sendable.to).to be_nil
        expect(sendable.created_at).to be_nil
        expect(sendable.content_url).to eq args[0]
        expect(sendable.audlen).to eq args[1]
      end
    end

    context 'in the case of a received message' do
      it 'returns the correct value' do
        expect(received.id).to eq attrs['id'].to_i
        expect(received.from).to eq attrs['from']
        expect(received.to).to eq attrs['to']
        expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
        expect(received.content_url).to be_nil
        expect(received.audlen).to eq attrs['contentMetadata']['AUDLEN'].to_i
      end
    end
  end

  describe '#to_h' do
    context 'in the case of a sendable message' do
      it 'returns a hash containing the required entries' do
        hash = {
          'contentType' => 4,
          'toType' => 1,
          'originalContentUrl' => args[0],
          'contentMetadata' => { 'AUDLEN' => args[1].to_s }
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
        str = '#<Line::Message::Audio id=nil>'
        expect(sendable.inspect).to eq str
      end
    end

    context 'in the case of a received message' do
      it 'returns a string containing the id' do
        str = "#<Line::Message::Audio id=#{attrs['id'].to_i.inspect}>"
        expect(received.inspect).to eq str
      end
    end
  end
end
