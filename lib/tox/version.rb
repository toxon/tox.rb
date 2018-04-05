# frozen_string_literal: true

module Tox
  ##
  # Gem, library API and ABI version strings and component numbers.
  #
  module Version
    # Gem version.
    GEM_VERSION = '0.0.2'

    def self.const_missing(name)
      return "#{API_MAJOR}.#{API_MINOR}.#{API_PATCH}" if name == :API_VERSION
      super
    end

    def self.abi_version
      "#{abi_major}.#{abi_minor}.#{abi_patch}"
    end
  end
end
