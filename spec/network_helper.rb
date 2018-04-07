# frozen_string_literal: true

# This should be on the top of the file.
require 'simplecov'

# This file configures and starts a fake Tox network before running test suite.

require 'spec_helper'

RSpec.configure do |config|
  config.before do # :suite do
    node_executable =
      File.expand_path('vendor/bin/tox-bootstrapd').freeze

    node_configs = [
      File.expand_path('config/node1_conf').freeze,
      File.expand_path('config/node2_conf').freeze,
      File.expand_path('config/node3_conf').freeze,
    ]

    @node_pids = node_configs.map do |node_config|
      Process.spawn(
        node_executable,
        '--foreground',
        '--log-backend',
        'stdout',
        '--config',
        node_config,
      )
    end

    @nodes = [
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
    ]
  end

  config.after do # :suite do
    @node_pids.each do |node_pid|
      Process.kill :SIGINT, node_pid
    end
  end
end
