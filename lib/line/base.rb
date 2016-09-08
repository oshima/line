module Line
  class Base
    class << self
      def new_with(attrs)
        allocate.tap do |instance|
          instance.instance_variable_set(:@attrs, attrs)
        end
      end

      def subclasses
        @subclasses || []
      end

      private

      def attr_reader(name, keychain, proc = nil)
        define_method(name) do
          return unless @attrs
          val = @attrs.dig(*keychain.split('.'))
          proc && val ? proc[val] : val
        end
      end

      def inherited(subclass)
        @subclasses ||= []
        @subclasses << subclass
      end
    end

    def to_h
      @attrs || {}
    end
  end
end
