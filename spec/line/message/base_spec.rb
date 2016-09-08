describe Line::Message::Base do
  describe '.subclasses' do
    it 'returns an array of the subclasses' do
      arr = [
        Line::Message::Audio,
        Line::Message::Contact,
        Line::Message::Image,
        Line::Message::Location,
        Line::Message::RichMessage,
        Line::Message::Sticker,
        Line::Message::Text,
        Line::Message::Video
      ]
      expect(Line::Message::Base.subclasses).to match_array arr
    end
  end
end
