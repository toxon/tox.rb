# frozen_string_literal: true

module Support
  module FakeToxNetwork
    extend RSpec::SharedContext

    ROOT_DIR = File.expand_path('../..', __dir__).freeze

    before do
      fake_node_pids
    end

    after do
      fake_node_pids.each do |fake_node_pid|
        Process.kill :SIGINT, fake_node_pid
      end
    end

    let :fake_node_executable do
      File.join(ROOT_DIR, 'vendor/bin/tox-bootstrapd').freeze
    end

    let :fake_node_configs do
      [
        File.join(ROOT_DIR, 'config/node1_conf').freeze,
        File.join(ROOT_DIR, 'config/node2_conf').freeze,
        File.join(ROOT_DIR, 'config/node3_conf').freeze,
      ].freeze
    end

    let :fake_node_pids do
      fake_node_configs.map do |fake_node_config|
        Process.spawn(
          fake_node_executable,
          '--foreground',
          '--log-backend',
          'stdout',
          '--config',
          fake_node_config,
        )
      end.freeze
    end

    let :fake_nodes do
      [
        Tox::Node.new(
          ipv4: '127.0.0.1',
          port: 10_100,
          public_key: 'A8020928C0B6AE8665A532C1084D1344' \
                      'CCC96724670122A1CB879E36F85A7D60',
        ),
        Tox::Node.new(
          ipv4: '127.0.0.1',
          port: 10_200,
          public_key: '88A8100DEEDE5223603231768C64BDF0' \
                      '27667C0ADC58ED006DED26D1881E1122',
        ),
        Tox::Node.new(
          ipv4: '127.0.0.1',
          port: 10_300,
          public_key: '89D8F36C2201371B9B3CD3EE7EC8E834' \
                      '319FEE8014E02F949BDD2DE7E5E5167D',
        ),
      ].freeze
    end
  end
end
