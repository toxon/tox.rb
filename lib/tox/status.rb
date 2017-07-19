# frozen_string_literal: true

module Tox
  ##
  # Tox network status from multiple sources.
  #
  module Status
    def self.official
      Official.new
    end
  end
end
