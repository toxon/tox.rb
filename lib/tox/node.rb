# frozen_string_literal: true

module Tox
  ##
  # Tox node credentials.
  #
  class Node
    using CoreExt
    include Helpers

    def initialize(data)
      @data = data.map { |k, v| [k.to_sym, v] }.to_h.freeze
    end

    def ipv4
      @ipv4 ||= begin
        value = @data[:ipv4]
        String.ancestor_of! value
        value.dup_and_freeze
      end
    end

    def ipv6
      @ipv6 ||= begin
        value = @data[:ipv6]
        String.ancestor_of! value
        value.dup_and_freeze
      end
    end

    def port
      @port ||= valid_port! @data[:port]
    end

    def tcp_ports
      @tcp_ports ||= begin
        value = @data[:tcp_ports]

        Array.ancestor_of! value

        value.map(&method(:valid_port!)).freeze
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
        value.dup_and_freeze
      end
    end

    def location
      @location ||= begin
        value = @data[:location]
        String.ancestor_of! value
        value.dup_and_freeze
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
        value.dup_and_freeze
      end
    end

    def motd
      @motd ||= begin
        value = @data[:motd]
        String.ancestor_of! value
        value.dup_and_freeze
      end
    end

    def resolv_ipv4
      @resolv_ipv4 ||= Resolv.getaddress(ipv4).freeze
    end
  end
end
