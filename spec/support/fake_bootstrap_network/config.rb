# frozen_string_literal: true

require 'erb'

module Support
  module FakeBootstrapNetwork
    class Config # rubocop:disable Metrics/ClassLength
      TEMPLATE_FILE_PATH = File.expand_path('config.erb', __dir__).freeze

      PORT_RANGE = 1..65_535

      REQUIRED_KEYS = %i[
        keys_file_path
        pid_file_path
        port
        enable_ipv6
        enable_ipv4_fallback
        enable_lan_discovery
        enable_tcp_relay
        tcp_relay_ports
        enable_motd
        motd
        bootstrap_nodes
      ].freeze

      def self.encode(s)
        "\"#{encode_raw(s)}\""
      end

      def self.encode_raw(s)
        s                             #=> "\xAA\x00\xFF"
          .unpack('H*')               #=> ['aa00ff']
          .first                      #=> 'aa00ff'
          .upcase                     #=> 'AA00FF'
          .each_char                  #=> ['A', 'A', '0', '0', 'F', 'F']
          .each_slice(2)              #=> [['A', 'A'], ['0', '0'], ['F', 'F']]
          .to_a
          .map { |a| "\\x#{a.join}" } #=> ['\\xAA', '\\x00', '\\xFF']
          .join                       #=> '\\xAA\\x00\\xFF'
          .freeze
      end

      attr_reader :port, :enable_ipv6, :enable_ipv4_fallback,
                  :enable_lan_discovery, :enable_tcp_relay, :tcp_relay_ports,
                  :enable_motd, :bootstrap_nodes

      def initialize(options)
        REQUIRED_KEYS.each do |key|
          send :"#{key}=", options[key]
        end
      end

      def keys_file_path
        self.class.encode @keys_file_path
      end

      def pid_file_path
        self.class.encode @pid_file_path
      end

      def motd
        self.class.encode @motd
      end

      def template
        @template ||= File.read(TEMPLATE_FILE_PATH).freeze
      end

      def erb
        @erb ||= ERB.new(template, nil, '<>').freeze
      end

      def render
        @render ||= erb.result(binding).freeze
      end

    private

      def keys_file_path=(value)
        unless value.is_a? String
          raise TypeError, "Expected #{String}, got #{value.class}"
        end
        @keys_file_path = value.frozen? ? value : value.dup.freeze
      end

      def pid_file_path=(value)
        unless value.is_a? String
          raise TypeError, "Expected #{String}, got #{value.class}"
        end
        @pid_file_path = value.frozen? ? value : value.dup.freeze
      end

      def port=(value)
        unless value.is_a? Integer
          raise TypeError, "Expected #{Integer}, got #{value.class}"
        end
        unless PORT_RANGE.include? value
          raise "Expected value to be from range #{PORT_RANGE}"
        end
        @port = value
      end

      def enable_ipv6=(value)
        @enable_ipv6 = !!value
      end

      def enable_ipv4_fallback=(value)
        @enable_ipv4_fallback = !!value
      end

      def enable_lan_discovery=(value)
        @enable_lan_discovery = !!value
      end

      def enable_tcp_relay=(value)
        @enable_tcp_relay = !!value
      end

      def tcp_relay_ports=(value)
        @tcp_relay_ports = Array.new(value).map do |item|
          unless item.is_a? Integer
            raise TypeError, "Expected #{Integer}, got #{item.class}"
          end
          unless PORT_RANGE.include? item
            raise "Expected value to be from range #{PORT_RANGE}"
          end
          item
        end.freeze
      end

      def enable_motd=(value)
        @enable_motd = !!value
      end

      def motd=(value)
        unless value.is_a? String
          raise TypeError, "Expected #{String}, got #{value.class}"
        end
        @motd = value.frozen? ? value : value.dup.freeze
      end

      def bootstrap_nodes=(value)
        @bootstrap_nodes = Array.new(value).map do |item|
          Node.new item
        end.freeze
      end

      class Node
        attr_reader :port

        def initialize(address:, port:, public_key:)
          self.address = address
          self.port = port
          self.public_key = public_key
        end

        def address
          Config.encode @address
        end

        def public_key
          Config.encode @public_key
        end

      private

        def address=(value)
          unless value.is_a? String
            raise TypeError, "Expected #{String}, got #{value.class}"
          end
          @address = value.frozen? ? value : value.dup.freeze
        end

        def port=(value)
          unless value.is_a? Integer
            raise TypeError, "Expected #{Integer}, got #{value.class}"
          end
          unless PORT_RANGE.include? value
            raise "Expected value to be from range #{PORT_RANGE}"
          end
          @port = value
        end

        def public_key=(value)
          unless value.is_a? String
            raise TypeError, "Expected #{String}, got #{value.class}"
          end
          @public_key = value.frozen? ? value : value.dup.freeze
        end
      end
    end
  end
end
