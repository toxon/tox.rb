# frozen_string_literal: true

module Tox
  module Proxies
    ##
    # @abstract
    # Base class for proxy used to connect to TCP relays.
    #
    class Base
      using CoreExt

      include Helpers

      HOST_MAX_BYTESIZE = 255

      attr_reader :host, :port

      abstract_method :type

      def initialize(host, port)
        self.host = host
        self.port = port
      end

      def ==(other)
        self.class == other.class &&
          host == other.host &&
          port == other.port
      end

    private

      def host=(value)
        String.ancestor_of! value
        unless value.bytesize <= HOST_MAX_BYTESIZE
          raise 'Proxy host string can not ' \
                "be longer than #{HOST_MAX_BYTESIZE} bytes"
        end
        @host = value.dup_and_freeze
      end

      def port=(value)
        @port = valid_port! value
      end
    end
  end
end
