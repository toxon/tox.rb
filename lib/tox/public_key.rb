# frozen_string_literal: true

module Tox
  ##
  # Public key primitive.
  #
  class PublicKey < String
    BYTESIZE = 32

    HEX_RE = /\A[\da-fA-F]{64}\z/

    def initialize(value, binary: false)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String

      if binary
        raise ArgumentError, "expected value to have bytesize #{BYTESIZE}" unless value.bytesize == BYTESIZE
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
