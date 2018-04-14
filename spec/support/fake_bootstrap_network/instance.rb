# frozen_string_literal: true

require 'support/fake_bootstrap_network/process'
require 'support/fake_bootstrap_network/config'

module Support
  module FakeBootstrapNetwork
    class Instance
      PORT_RANGE = 1..65_535
      PUBLIC_KEY_RE = /^Public Key: ([0-9A-Z]{#{2 * Tox::PublicKey.bytesize}})$/

      TIMEOUT = 2
      SLEEP = 0.01

      DEFAULT_CONFIG_PARAMS = {
        keys_file_path: '/dev/null',
        pid_file_path: '/dev/null',
        port: 0,
        enable_ipv6: false,
        enable_ipv4_fallback: true,
        enable_lan_discovery: false,
        enable_tcp_relay: false,
        tcp_relay_ports: [],
        enable_motd: false,
        motd: '',
        bootstrap_nodes: [],
      }.freeze

      attr_reader :port, :public_key

      def initialize(port:)
        self.port = port
        write_initial_config
        obtain_public_key
        raise 'Can not obtain public key' if public_key.nil?
      end

      def datadir
        @datadir ||= Dir.mktmpdir('tox-').freeze
      end

      def initial_config_file_path
        @initial_config_file_path ||= File.join(datadir, 'initialconfig').freeze
      end

      def config_file_path
        @config_file_path ||= File.join(datadir, 'config').freeze
      end

      def keys_file_path
        @keys_file_path ||= File.join(datadir, 'keys').freeze
      end

      def pid_file_path
        @pid_file_path ||= File.join(datadir, 'pid').freeze
      end

      def build_config(bootstrap_nodes)
        Config.new(
          DEFAULT_CONFIG_PARAMS.merge(
            keys_file_path:  keys_file_path,
            pid_file_path:   pid_file_path,
            port:            port,
            bootstrap_nodes: bootstrap_nodes,
          ),
        )
      end

    private

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
        value = Tox::PublicKey.new value unless value.is_a? Tox::PublicKey
        @public_key = value
      end

      def write_initial_config
        File.write initial_config_file_path, build_config([]).render
      end

      def obtain_public_key
        process = Process.new initial_config_file_path
        Timeout.timeout TIMEOUT do
          sleep SLEEP while process.stdout_lines.grep(PUBLIC_KEY_RE).empty?
        end
        process.stdout_lines.grep(PUBLIC_KEY_RE).first&.tap do |s|
          self.public_key = s.match(PUBLIC_KEY_RE)[1]
        end
      ensure
        process&.close
      end
    end
  end
end
