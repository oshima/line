describe Line::User do
  let(:attrs) do
    {
      "displayName" => "foo",
      "mid" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "pictureUrl" => "http://dl.profile.line-cdn.net/1111111111111111111111111111111111111111111111",
      "statusMessage" => "hello"
    }
  end

  let(:user) { Line::User.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    it 'returns the correct value' do
      expect(user.mid).to eq attrs['mid']
      expect(user.display_name).to eq attrs['displayName']
      expect(user.picture_url).to eq attrs['pictureUrl']
      expect(user.status_message).to eq attrs['statusMessage']
    end
  end

  describe '#to_h' do
    it 'returns the received hash' do
      expect(user.to_h).to eq attrs
    end
  end

  describe '#inspect' do
    it 'returns a string containing the mid' do
      str = "#<Line::User mid=#{attrs['mid'].inspect}>"
      expect(user.inspect).to eq str
    end
  end
end
