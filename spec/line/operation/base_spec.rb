describe Line::Operation::Base do
  describe '.subclasses' do
    it 'returns an array of the subclasses' do
      arr = [
        Line::Operation::Adding,
        Line::Operation::Blocking
      ]
      expect(Line::Operation::Base.subclasses).to match_array arr
    end
  end
end
