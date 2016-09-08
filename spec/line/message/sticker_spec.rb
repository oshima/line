describe Line::Message::Sticker do
  let(:args) { [1, 1, 100] }

  let(:attrs) do
    {
      "toType" => 1,
      "createdTime" => 1471710813000,
      "from" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "location" => nil,
      "id" => "1111111111111",
      "to" => ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "text" => nil,
      "contentMetadata" =>
      {
        "STKTXT" => "[ビシッ]",
        "AT_RECV_MODE" => "2",
        "STKVER" => "100",
        "STKID" => "13",
        "STKPKGID" => "1",
        "SKIP_BADGE_COUNT" => "true"
      },
      "deliveredTime" => 0,
      "contentType" => 8,
      "seq" => nil
    }
  end

  let(:sendable1) { Line::Message::Sticker.new(*args[0..1].deep_dup) } # omit args[2]

  let(:sendable2) { Line::Message::Sticker.new(*args.deep_dup) }

  let(:received) { Line::Message::Sticker.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    context 'in the case of a sendable message' do
      it 'returns the correct value' do
        expect(sendable1.id).to be_nil
        expect(sendable1.from).to be_nil
        expect(sendable1.to).to be_nil
        expect(sendable1.created_at).to be_nil
        expect(sendable1.stkid).to eq args[0]
        expect(sendable1.stkpkgid).to eq args[1]
        expect(sendable1.stkver).to be_nil
        expect(sendable1.stktxt).to be_nil

        expect(sendable2.id).to be_nil
        expect(sendable2.from).to be_nil
        expect(sendable2.to).to be_nil
        expect(sendable2.created_at).to be_nil
        expect(sendable2.stkid).to eq args[0]
        expect(sendable2.stkpkgid).to eq args[1]
        expect(sendable2.stkver).to eq args[2]
        expect(sendable2.stktxt).to be_nil
      end
    end

    context 'in the case of a received message' do
      it 'returns the correct value' do
        expect(received.id).to eq attrs['id'].to_i
        expect(received.from).to eq attrs['from']
        expect(received.to).to eq attrs['to']
        expect(received.created_at).to eq Time.at(attrs['createdTime'] / 1000)
        expect(received.stkid).to eq attrs['contentMetadata']['STKID'].to_i
        expect(received.stkpkgid).to eq attrs['contentMetadata']['STKPKGID'].to_i
        expect(received.stkver).to eq attrs['contentMetadata']['STKVER'].to_i
        expect(received.stktxt).to eq attrs['contentMetadata']['STKTXT']
      end
    end
  end

  describe '#to_h' do
    context 'in the case of a sendable message' do
      it 'returns a hash containing the required entries' do
        hash = {
          'contentType' => 8,
          'toType' => 1,
          'contentMetadata' => {
            'STKID' => args[0].to_s,
            'STKPKGID' => args[1].to_s
          }
        }
        expect(sendable1.to_h).to eq hash

        hash['contentMetadata']['STKVER'] = args[2].to_s
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
        str = '#<Line::Message::Sticker id=nil>'
        expect(sendable1.inspect).to eq str
        expect(sendable2.inspect).to eq str
      end
    end

    context 'in the case of a received message' do
      it 'returns a string containing the id' do
        str = "#<Line::Message::Sticker id=#{attrs['id'].to_i.inspect}>"
        expect(received.inspect).to eq str
      end
    end
  end
end
