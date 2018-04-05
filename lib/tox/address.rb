# frozen_string_literal: true

module Tox
  ##
  # Address primitive.
  #
  class Address < Binary
    def self.bytesize
      38
    end

    def public_key
      @public_key ||= PublicKey.new value[0...32]
    end

    def nospam
      @nospam ||= Nospam.new value[32...36]
    end
  end
end
