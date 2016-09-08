describe Line::Message::Contact do
  let(:attrs) do
    {
      "toType" => 1,
      "createdTime" => 1471710813000,
      "from" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "location" => nil,
      "id" => "1111111111111",
      "to" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "text" => nil,
      "contentMetadata" =>  {
        "mid" => "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
        "AT_RECV_MODE" => "2",
        "displayName" => "foo",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 10,
      "seq" => nil
    }
  end

  let(:received) { Line::Message::Contact.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    it 'returns the correct value' do
      expect(received.id).to eq attrs['id'].to_i
      expect(received.from).to eq attrs['from']
      expect(received.to).to eq attrs['to']
      expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
      expect(received.mid).to eq attrs['contentMetadata']['mid']
      expect(received.display_name).to eq attrs['contentMetadata']['displayName']
    end
  end

  describe '#to_h' do
    it 'returns the received hash' do
      expect(received.to_h).to eq attrs
    end
  end

  describe '#inspect' do
    it 'returns a string containing the id' do
      str = "#<Line::Message::Contact id=#{attrs['id'].to_i.inspect}>"
      expect(received.inspect).to eq str
    end
  end
end
