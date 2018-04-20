# frozen_string_literal: true

module Tox
  ##
  # Nospam primitive.
  #
  class Nospam < Binary
    def self.bytesize
      4
    end

    def initialize(value)
      if value.is_a? Integer
        @value = [value].pack('L').reverse.freeze
        return
      end

      super
    end

    def to_i
      @to_i ||= value.reverse.unpack('L').first
    end
  end
end
