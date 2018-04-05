# frozen_string_literal: true

module Tox
  ##
  # Binary primitive representation.
  #
  class Binary
    def self.bytesize
      raise NotImplementedError, "#{self}.bytesize"
    end

    def self.hex_re
      /\A[\da-fA-F]{#{2 * bytesize}}\z/
    end

    attr_reader :value

    def initialize(value)
      unless value.is_a? String
        raise TypeError, "expected value to be a #{String}"
      end

      if value.bytesize == self.class.bytesize
        self.value = value
      elsif value =~ self.class.hex_re
        self.hex_value = value
      else
        raise ArgumentError, 'expected value to be a hex or binary string'
      end
    end

    def to_s
      @to_s ||= value.unpack('H*').first.upcase.freeze
    end

    def inspect
      "#<#{self.class}: \"#{self}\">"
    end

    def ==(other)
      return false unless self.class == other.class
      value == other.value
    end

  private

    def value=(value)
      @value = value.frozen? ? value : value.dup.freeze
    end

    def hex_value=(value)
      @value = [value].pack('H*').freeze
    end
  end
end
