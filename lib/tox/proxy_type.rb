# frozen_string_literal: true

module Tox
  ##
  # Type of proxy used to connect to TCP relays.
  #
  module ProxyType
    # Don't use a proxy.
    NONE = :none

    # HTTP proxy using CONNECT.
    HTTP = :http

    # SOCKS proxy for simple socket pipes.
    SOCKS5 = :socks5
  end
end
