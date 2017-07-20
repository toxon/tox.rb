# frozen_string_literal: true

module Tox
  ##
  # Binary primitive representation.
  #
  class Binary < String
    HEX_RE = /\A[\da-fA-F]{64}\z/

    def self.from_binary(value)
      new value, binary: true
    end

    def initialize(value, binary: false)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String

      if binary
        raise ArgumentError, "expected #{self.class.bytesize} bytes" unless value.bytesize == self.class.bytesize
        super value
      else
        raise ArgumentError, 'expected value to be a hex string' unless value =~ HEX_RE
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
