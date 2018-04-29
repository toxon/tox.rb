# frozen_string_literal: true

module Tox
  ##
  # Startup options for Tox client.
  #
  class Options
    using CoreExt

    BIND_PORT_RANGE = 0..65_535

    attr_reader :proxy

    def proxy=(value)
      if value.nil?
        @proxy = nil
        set_proxy_params ProxyType::NONE, nil, 0
        return
      end
      Proxies::Base.ancestor_of! value
      @proxy = value
      set_proxy_params value.type, value.host, value.port
    end

    def start_port=(value)
      Integer.ancestor_of! value
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.start_port_internal = value
    end

    def end_port=(value)
      Integer.ancestor_of! value
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.end_port_internal = value
    end

    def tcp_port=(value)
      Integer.ancestor_of! value
      unless BIND_PORT_RANGE.include? value
        raise "Expected value to be from range #{BIND_PORT_RANGE}"
      end
      self.tcp_port_internal = value
    end

  private

    def set_proxy_params(type, host, port)
      self.proxy_type = type
      self.proxy_host = host
      self.proxy_port = port
    end
  end
end
