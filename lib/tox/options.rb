# frozen_string_literal: true

module Tox
  ##
  # Startup options for Tox client.
  #
  class Options
    using CoreExt
    include Helpers

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
      self.start_port_internal = valid_bind_port! value, allow_zero: true
    end

    def end_port=(value)
      self.end_port_internal = valid_bind_port! value, allow_zero: true
    end

    def tcp_port=(value)
      self.tcp_port_internal = valid_bind_port! value, allow_zero: true
    end

  private

    def set_proxy_params(type, host, port)
      self.proxy_type = type
      self.proxy_host = host
      self.proxy_port = port
    end
  end
end
