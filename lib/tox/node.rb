# frozen_string_literal: true

module Tox
  ##
  # Tox node credentials.
  #
  class Node
    using CoreExt

    # Range of valid port numbers.
    PORT_RANGE = 1..65_535

    def initialize(data)
      @data = data.map { |k, v| [k.to_sym, v] }.to_h.freeze
    end

    def ipv4
      @ipv4 ||= begin
        value = @data[:ipv4]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def ipv6
      @ipv6 ||= begin
        value = @data[:ipv6]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def port
      @port ||= begin
        value = @data[:port]
        Integer.ancestor_of! value
        unless PORT_RANGE.include? value
          raise "Expected value to be from range #{PORT_RANGE}"
        end
        value
      end
    end

    def tcp_ports
      @tcp_ports ||= begin
        value = @data[:tcp_ports]
        Array.ancestor_of! value
        value.map do |item|
          Integer.ancestor_of! item
          unless PORT_RANGE.include? item
            raise "Expected value to be from range #{PORT_RANGE}"
          end
          item
        end.freeze
      end
    end

    def public_key
      @public_key ||= begin
        value = @data[:public_key]
        PublicKey.new value
      end
    end

    def maintainer
      @maintainer ||= begin
        value = @data[:maintainer]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def location
      @location ||= begin
        value = @data[:location]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def status_udp
      @status_udp ||= !!@data[:status_udp]
    end

    def status_tcp
      @status_tcp ||= !!@data[:status_tcp]
    end

    def version
      @version ||= begin
        value = @data[:version]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def motd
      @motd ||= begin
        value = @data[:motd]
        String.ancestor_of! value
        value.frozen? ? value : value.dup.freeze
      end
    end

    def resolv_ipv4
      @resolv_ipv4 ||= Resolv.getaddress(ipv4).freeze
    end
  end
end
