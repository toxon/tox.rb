# frozen_string_literal: true

# This should be on the top of the file.
require 'simplecov'

# This file configures and starts a fake Tox network before running test suite.

require 'spec_helper'

require 'support/fake_bootstrap_network'

RSpec.configure do |config|
  config.include Support::FakeBootstrapNetwork

  config.before :suite do
    Support::FakeBootstrapNetwork.start
  end

  config.after :suite do
    Support::FakeBootstrapNetwork.stop
  end
end
