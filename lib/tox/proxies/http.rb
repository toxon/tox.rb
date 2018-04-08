# frozen_string_literal: true

module Tox
  module Proxies
    ##
    # HTTP proxy used to connect to TCP relays.
    #
    class HTTP < Base
      def type
        ProxyType::HTTP
      end
    end
  end
end
