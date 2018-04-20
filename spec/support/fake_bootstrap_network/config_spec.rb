# frozen_string_literal: true

require 'support/fake_bootstrap_network/config'

RSpec.describe Support::FakeBootstrapNetwork::Config do
  subject do
    described_class.new(
      keys_file_path: 'keys',
      pid_file_path: 'pid',
      port: 10_100,
      enable_ipv6: false,
      enable_ipv4_fallback: true,
      enable_lan_discovery: false,
      enable_tcp_relay: false,
      tcp_relay_ports: [10_101, 10_102, 10_103],
      enable_motd: false,
      motd: 'motd',
      bootstrap_nodes: [
        {
          address: '127.0.0.1',
          port: 10_100,
          public_key: 'public_key',
        },
      ],
    )
  end

  describe '#render' do
    it 'works' do
      expect(subject.render).to eq <<~CONFIG
        keys_file_path = "\\x6B\\x65\\x79\\x73"
        pid_file_path = "\\x70\\x69\\x64"
        port = 10100
        enable_ipv6 = false
        enable_ipv4_fallback = true
        enable_lan_discovery = false
        enable_tcp_relay = false
        tcp_relay_ports = [10101, 10102, 10103]
        enable_motd = false
        motd = "\\x6D\\x6F\\x74\\x64"
        bootstrap_nodes = (
          {
            address = "\\x31\\x32\\x37\\x2E\\x30\\x2E\\x30\\x2E\\x31"
            port = 10100
            public_key = "\\x70\\x75\\x62\\x6C\\x69\\x63\\x5F\\x6B\\x65\\x79"
          }
        )
      CONFIG
    end
  end
end
