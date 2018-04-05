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
      return @value = [value].pack('L').reverse.freeze if value.is_a? Integer
      super
    end
  end
end
