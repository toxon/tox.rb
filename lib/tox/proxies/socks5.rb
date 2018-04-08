# frozen_string_literal: true

module Tox
  module Proxies
    ##
    # SOCKS5 proxy used to connect to TCP relays.
    #
    class SOCKS5 < Base
      def type
        ProxyType::SOCKS5
      end
    end
  end
end
