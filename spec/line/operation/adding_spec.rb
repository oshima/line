describe Line::Operation::Adding do
  let(:attrs) do
    {
      "params" => ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", nil, nil],
      "message" => nil,
      "reqSeq" => 0,
      "revision" => 111,
      "opType" => 8
    }
  end

  let(:received) { Line::Operation::Adding.new_with(attrs.deep_dup) }

  describe '#<attr_reader>' do
    it 'returns the correct value' do
      expect(received.revision).to eq attrs['revision']
      expect(received.from).to eq attrs['params'][0]
    end
  end

  describe '#to_h' do
    it 'returns the received hash' do
      expect(received.to_h).to eq attrs
    end
  end

  describe '#inspect' do
    it 'returns a string containing the revision' do
      str = "#<Line::Operation::Adding revision=#{attrs['revision'].inspect}>"
      expect(received.inspect).to eq str
    end
  end
end
