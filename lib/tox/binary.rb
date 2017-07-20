# frozen_string_literal: true

module Tox
  ##
  # Binary primitive representation.
  #
  class Binary < String
    def self.bytesize
      raise NotImplementedError, "#{self}.bytesize"
    end

    def self.hex_re
      /\A[\da-fA-F]{#{2 * bytesize}}\z/
    end

    def initialize(value)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String

      if value.bytesize == self.class.bytesize
        super value
      else
        raise ArgumentError, 'expected value to be a hex string' unless value =~ self.class.hex_re
        super [value].pack('H*')
      end

      to_hex
      freeze
    end

    def to_hex
      @to_hex ||= unpack('H*').first.upcase.freeze
    end

    def inspect
      "#<#{self.class}: \"#{to_hex}\">"
    end
  end
end
