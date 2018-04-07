# frozen_string_literal: true

module Tox
  ##
  # Tox node credentials.
  #
  class Node
    # Range of valid port numbers.
    PORT_RANGE = 1..65_535

    def initialize(data)
      @data = data.map { |k, v| [k.to_sym, v] }.to_h.freeze
    end

    def ipv4
      @ipv4 ||=
        begin
          value = @data[:ipv4]
          unless value.is_a? String
            raise TypeError, "expected value to be a #{String}"
          end
          value.frozen? ? value : value.dup.freeze
        end
    end

    def port
      @port ||= begin
        value = @data[:port]
        unless value.is_a? Integer
          raise TypeError, "expected value to be an #{Integer}"
        end
        unless PORT_RANGE.cover? value
          raise ArgumentError, 'expected value to be between 0 and 65535'
        end
        value
      end
    end

    def public_key
      @public_key ||=
        begin
          value = @data[:public_key]
          PublicKey.new value
        end
    end

    def status_udp
      @status_udp ||= !!@data[:status_udp]
    end

    def status_tcp
      @status_tcp ||= !!@data[:status_tcp]
    end

    def resolv_ipv4
      @resolv_ipv4 ||= Resolv.getaddress ipv4
    end
  end
end
