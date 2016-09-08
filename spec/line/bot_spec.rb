describe Line::Bot do
  let(:bot) do
    Line::Bot.new do |config|
      config.channel_id     = 9999999999,
      config.channel_secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      config.channel_mid    = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
    end
  end

  let(:base_url) { 'https://trialbot-api.line.me/v1' }

  let(:received_json) do
    <<EOS
{
  "result": [
    {
      "content": {
        "toType": 1,
        "createdTime": 1471597209277,
        "from": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "location": null,
        "id": "1111111111111",
        "to": ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
        "text": "Hello",
        "contentMetadata": {
          "AT_RECV_MODE": "2",
          "SKIP_BADGE_COUNT": "true"
        },
        "deliveredTime": 0,
        "contentType": 1,
        "seq": null
      },
      "createdTime": 1471597209314,
      "eventType": "138311609000106303",
      "from": "ccccccccccccccccccccccccccccccccc",
      "fromChannel": 1111111111,
      "id": "WB1111-1111111111",
      "to": ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "toChannel": 9999999999
    },
    {
      "content": {
        "params": [
          "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
          null,
          null
        ],
        "message": null,
        "reqSeq": 0,
        "revision": 111,
        "opType": 4
      },
      "createdTime": 1471597209314,
      "eventType": "138311609100106403",
      "from": "ccccccccccccccccccccccccccccccccc",
      "fromChannel": 1111111111,
      "id": "WB2222-2222222222",
      "to": ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"],
      "toChannel": 9999999999
    }
  ]
}
EOS
  end

  let(:user_json) do
    <<EOS
{
  "contacts": [
    {
      "displayName": "foo",
      "mid": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "pictureUrl": "",
      "statusMessage": ""
    }
  ],
  "count": 1,
  "display": 1,
  "pagingRequest": {
    "start": 1,
    "display": 1,
    "sortBy": "MID"
  },
  "start": 1,
  "total": 1
}
EOS
  end

    let(:users_json) do
    <<EOS
{
  "contacts": [
    {
      "displayName": "foo",
      "mid": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "pictureUrl": "",
      "statusMessage": ""
    },
    {
      "displayName": "bar",
      "mid": "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      "pictureUrl": "",
      "statusMessage": ""
    }
  ],
  "count": 2,
  "display": 2,
  "pagingRequest": {
    "start": 1,
    "display": 2,
    "sortBy": "MID"
  },
  "start": 1,
  "total": 2
}
EOS
  end

  describe '#validate_request' do
    it 'returns false if the signature is nil' do
      signature = nil
      body = '{"foo": 1}'
      expect(bot.validate_request(signature, body)).to be_falsey
    end

    it 'returns false if the signature is not correct' do
      signature = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
      body = '{"foo": 1}'
      expect(bot.validate_request(signature, body)).to be_falsey
    end

    it 'returns true if the signature is correct' do
      signature = 'ZpV1TtvSrQF/bcXFCzjeeAltby4aqPSfEzvR/8Eh9eo='
      body = '{"foo": 1}'
      expect(bot.validate_request(signature, body)).to be_truthy
    end
  end

  describe '#parse_request' do
    it 'returns an array of the received messages or operations' do
      arr = bot.parse_request(received_json)
      expect(arr.size).to eq 2
      expect(arr[0]).to be_a Line::Message::Text
      expect(arr[0].id).to eq 1111111111111
      expect(arr[1]).to be_a Line::Operation::Adding
      expect(arr[1].revision).to eq 111
    end
  end

  describe '#get_content' do
    it 'returns a content file of the specified message' do
      id = 1111111111111
      stub_request(:get, "#{base_url}/bot/message/#{id}/content")
        .to_return(headers: { 'Content-Disposition' => 'attachment; filename="S__11111111.jpg"'}, body: 'foo')

      file = bot.get_content(id)
      expect(file).to be_a Line::File
      expect(file.name).to eq 'S__11111111.jpg'
      expect(file.data).to eq 'foo'
    end
  end

  describe '#get_preview' do
    it 'returns a content preview file of the specified message' do
      id = 1111111111111
      stub_request(:get, "#{base_url}/bot/message/#{id}/content/preview")
        .to_return(headers: { 'Content-Disposition' => 'attachment; filename="S__22222222.jpg"'}, body: 'bar')

      file = bot.get_preview(id)
      expect(file).to be_a Line::File
      expect(file.name).to eq 'S__22222222.jpg'
      expect(file.data).to eq 'bar'
    end
  end

  describe '#get_user' do
    it 'returns the specified user' do
      mid = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      stub_request(:get, "#{base_url}/profiles?mids=#{mid}")
        .to_return(body: user_json)

      user = bot.get_user(mid)
      expect(user).to be_a Line::User
      expect(user.mid).to eq mid
    end
  end

  describe '#get_users' do
    it 'returns an array of the specified users' do
      mids = ['aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb']
      stub_request(:get, "#{base_url}/profiles?mids=#{mids.join(',')}")
        .to_return(body: users_json)

      users = bot.get_users(mids)
      expect(users).to be_a Array
      expect(users.size).to eq 2
      expect(users[0]).to be_a Line::User
      expect(users[0].mid).to eq mids[0]
      expect(users[1]).to be_a Line::User
      expect(users[1].mid).to eq mids[1]
    end
  end
end
