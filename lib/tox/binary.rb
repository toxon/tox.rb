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
        @value = value.frozen? ? value : value.dup.freeze
      elsif value =~ self.class.hex_re
        @value = [value].pack('H*').freeze
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
  end
end
