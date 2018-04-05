# frozen_string_literal: true

module Tox
  ##
  # Public key primitive.
  #
  class PublicKey < Binary
    def self.bytesize
      32
    end
  end
end
