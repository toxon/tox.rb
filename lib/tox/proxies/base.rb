# frozen_string_literal: true

module Tox
  module Proxies
    ##
    # @abstract
    # Base class for proxy used to connect to TCP relays.
    #
    class Base
      using CoreExt

      HOST_MAX_BYTESIZE = 255
      PORT_RANGE = 1..65_535

      attr_reader :host, :port

      def initialize(host, port)
        self.host = host
        self.port = port
      end

      def type
        raise NotImplementedError, "#{self.class}#type"
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
        @host = value.frozen? ? value : value.dup.freeze
      end

      def port=(value)
        Integer.ancestor_of! value
        unless PORT_RANGE.include? value
          raise "Expected value to be from range #{PORT_RANGE}"
        end
        @port = value
      end
    end
  end
end
