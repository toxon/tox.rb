# frozen_string_literal: true

module Tox
  ##
  # Address primitive.
  #
  class Address < Binary
    def self.bytesize
      38
    end
  end
end
