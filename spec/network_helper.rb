# frozen_string_literal: true

# This should be on the top of the file.
require 'simplecov'

# This file configures and starts a fake Tox network before running test suite.

require 'spec_helper'

require 'support/fake_bootstrap_network'

ROOT_DIR = File.expand_path('..', __dir__).freeze

HTTP_PROXY_EXECUTABLE = File.join(ROOT_DIR, 'bin/proxy').freeze

HTTP_PROXY_PORT = rand 1024..65_535

RSpec.configure do |config|
  config.include Support::FakeBootstrapNetwork

  config.before :suite do
    $http_proxy_pid = Process.spawn(
      HTTP_PROXY_EXECUTABLE,
      HTTP_PROXY_PORT.to_s,
    )
  end

  config.after :suite do
    Process.kill :SIGINT, $http_proxy_pid
  end
end
