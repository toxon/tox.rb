# frozen_string_literal: true

module Tox
  ##
  # Address checksum primitive.
  #
  class AddressChecksum < Binary
    def self.bytesize
      2
    end
  end
end
