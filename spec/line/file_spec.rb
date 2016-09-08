describe Line::File do
  let(:file) { Line::File.new('foo.txt', 'xxxxxxxx') }

  describe '#<attr_reader>' do
    it 'returns the correct value' do
      expect(file.base).to eq 'foo'
      expect(file.ext).to eq '.txt'
      expect(file.data).to eq 'xxxxxxxx'
    end
  end

  describe '#<attr_writer>' do
    it 'rewrites the attribute correctly' do
      file.base = 'bar'
      file.ext = '.dat'
      expect(file.base).to eq 'bar'
      expect(file.ext).to eq '.dat'
    end
  end

  describe '#name' do
    it 'returns the filename' do
      expect(file.name).to eq 'foo.txt'
      file.base = 'bar'
      file.ext = '.dat'
      expect(file.name).to eq 'bar.dat'
    end
  end

  describe '#save_at' do
    let(:tmp_dir) do
      File.expand_path('../../../tmp', __FILE__) # <gem root>/tmp
    end

    before do
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    end

    after do
      File.delete("#{tmp_dir}/#{file.name}")
    end

    it 'saves the file at the specified directory' do
      file.save_at(tmp_dir)
      expect(File.exist?("#{tmp_dir}/#{file.name}")).to be_truthy
      expect(File.read("#{tmp_dir}/#{file.name}")).to eq file.data
    end
  end

  describe '#inspect' do
    it 'returns a string containing the filename' do
      expect(file.inspect).to eq '#<Line::File name="foo.txt">'
    end
  end
end
