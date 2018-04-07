# frozen_string_literal: true

module Tox
  ##
  # Startup options for Tox client.
  #
  class Options
    PORT_RANGE = 0..65_535

    def start_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless PORT_RANGE.include? value
        raise "Expected value to be from range #{PORT_RANGE}"
      end
      self.start_port_internal = value
    end

    def end_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless PORT_RANGE.include? value
        raise "Expected value to be from range #{PORT_RANGE}"
      end
      self.end_port_internal = value
    end

    def tcp_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless PORT_RANGE.include? value
        raise "Expected value to be from range #{PORT_RANGE}"
      end
      self.tcp_port_internal = value
    end
  end
end
