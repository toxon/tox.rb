# frozen_string_literal: true

module Tox
  ##
  # Helper methods.
  #
  module Helpers
    using CoreExt

    # Range of valid port numbers.
    PORT_RANGE = 1..65_535

    def valid_port!(value)
      Integer.ancestor_of! value
      unless PORT_RANGE.include? value
        raise "Expected value to be from range #{PORT_RANGE}"
      end
      value
    end
  end
end
