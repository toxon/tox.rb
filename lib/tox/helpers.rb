# frozen_string_literal: true

module Tox
  ##
  # Helper methods.
  #
  module Helpers
    using CoreExt

    # Range of valid port numbers.
    PORT_RANGE = 1..65_535

    # Range of valid bind port numbers.
    BIND_PORT_RANGE = 0..65_535

    def valid_port!(value)
      Integer.ancestor_of! value
      unless PORT_RANGE.include? value
        raise "Expected value to be from range #{PORT_RANGE}"
      end
      value
    end

    def valid_bind_port!(value, allow_zero:)
      Integer.ancestor_of! value
      port_range = allow_zero ? BIND_PORT_RANGE : PORT_RANGE
      unless port_range.include? value
        raise "Expected value to be from range #{port_range}"
      end
      value
    end
  end
end
