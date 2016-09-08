module Line
  class File
    attr_accessor :base, :ext
    attr_reader :data

    def initialize(name, data)
      @ext = ::File.extname(name)
      @base = ::File.basename(name, @ext)
      @data = data
    end

    def name
      @base + @ext
    end

    def save_at(dir)
      ::File.write(::File.join(dir, name), @data)
    end

    def inspect
      "#<#{self.class} name=#{name.inspect}>"
    end
  end
end
