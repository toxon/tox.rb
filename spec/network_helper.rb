# frozen_string_literal: true

# This should be on the top of the file.
require 'simplecov'

# This file configures and starts a fake Tox network before running test suite.

require 'spec_helper'

ROOT_DIR = File.expand_path('..', __dir__).freeze

FAKE_NODE_EXECUTABLE = File.join(ROOT_DIR, 'vendor/bin/tox-bootstrapd').freeze

FAKE_NODE_CONFIG_FILES = [
  File.join(ROOT_DIR, 'config/node1_conf').freeze,
  File.join(ROOT_DIR, 'config/node2_conf').freeze,
  File.join(ROOT_DIR, 'config/node3_conf').freeze,
].freeze

FAKE_NODES = [
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

RSpec.configure do |config|
  config.before :suite do
    $fake_node_pids = FAKE_NODE_CONFIG_FILES.map do |fake_node_config|
      Process.spawn(
        FAKE_NODE_EXECUTABLE,
        '--foreground',
        '--log-backend',
        'stdout',
        '--config',
        fake_node_config,
      )
    end.freeze
  end

  config.after :suite do
    $fake_node_pids.each do |fake_node_pid|
      Process.kill :SIGINT, fake_node_pid
    end
  end
end
