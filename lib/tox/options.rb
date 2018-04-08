# frozen_string_literal: true

module Tox
  ##
  # Startup options for Tox client.
  #
  class Options
    BIND_PORT_RANGE = 0..65_535

    attr_reader :proxy

    def proxy=(value)
      if value.nil?
        @proxy = nil
        self.proxy_type = ProxyType::NONE
        self.proxy_host = nil
        self.proxy_port_internal = 0
        return
      end
      unless value.is_a? Proxies::Base
        raise TypeError, "Expected #{Proxies::Base}, got #{value.class}"
      end
      @proxy = value
      self.proxy_type = value.type
      self.proxy_host = value.host
      self.proxy_port_internal = value.port
    end

    def start_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.start_port_internal = value
    end

    def end_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.end_port_internal = value
    end

    def tcp_port=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.tcp_port_internal = value
    end
  end
end
