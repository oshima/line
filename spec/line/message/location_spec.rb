describe Line::Message::Location do
  let(:args) do
    [
      '東京駅',
      35.681298,
      139.766247,
      '〒100-0005 東京都千代田区丸の内１丁目９'
    ]
  end

  let(:attrs) do
    {
      "toType" => 1,
      "createdTime" => 1471710813000,
      "from" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "location" =>  {
        "title" => "位置情報",
        "address" => " 〒105-0011 東京都港区芝公園４丁目２−８",
        "latitude" => 35.658581000000001,
        "longitude" => 139.74543300000001,
        "phone" => nil
      },
      "id" => "1111111111111",
      "to" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "text" => nil,
      "contentMetadata" => {
        "AT_RECV_MODE" => "2",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 7,
      "seq" => nil
    }
  end

  let(:sendable1) { Line::Message::Location.new(*args[0..2].deep_dup) } # omit args[3]

  let(:sendable2) { Line::Message::Location.new(*args.deep_dup) }

  let(:received) { Line::Message::Location.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    context 'in the case of a sendable message' do
      it 'returns the correct value' do
        expect(sendable1.id).to be_nil
        expect(sendable1.from).to be_nil
        expect(sendable1.to).to be_nil
        expect(sendable1.created_at).to be_nil
        expect(sendable1.title).to eq args[0]
        expect(sendable1.latitude).to eq args[1]
        expect(sendable1.longitude).to eq args[2]
        expect(sendable1.address).to be_nil

        expect(sendable2.id).to be_nil
        expect(sendable2.from).to be_nil
        expect(sendable2.to).to be_nil
        expect(sendable2.created_at).to be_nil
        expect(sendable2.title).to eq args[0]
        expect(sendable2.latitude).to eq args[1]
        expect(sendable2.longitude).to eq args[2]
        expect(sendable2.address).to eq args[3]
      end
    end

    context 'in the case of a received message' do
      it 'returns the correct value' do
        expect(received.id).to eq attrs['id'].to_i
        expect(received.from).to eq attrs['from']
        expect(received.to).to eq attrs['to']
        expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
        expect(received.title).to eq attrs['location']['title']
        expect(received.latitude).to eq attrs['location']['latitude']
        expect(received.longitude).to eq attrs['location']['longitude']
        expect(received.address).to eq attrs['location']['address']
      end
    end
  end

  describe '#to_h' do
    context 'in the case of a sendable message' do
      it 'returns a hash containing the required entries' do
        hash = {
          'contentType' => 7,
          'toType' => 1,
          'text' => args[0],
          'location' => {
            'title' => args[0],
            'latitude' => args[1],
            'longitude' => args[2]
          }
        }
        expect(sendable1.to_h).to eq hash

        hash['location']['address'] = args[3]
        expect(sendable2.to_h).to eq hash
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
        str = '#<Line::Message::Location id=nil>'
        expect(sendable1.inspect).to eq str
        expect(sendable2.inspect).to eq str
      end
    end

    context 'in the case of a received message' do
      it 'returns a string containing the id' do
        str = "#<Line::Message::Location id=#{attrs['id'].to_i.inspect}>"
        expect(received.inspect).to eq str
      end
    end
  end
end
