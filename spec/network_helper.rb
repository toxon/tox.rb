# frozen_string_literal: true

# This should be on the top of the file.
require 'simplecov'

# This file configures and starts a fake Tox network before running test suite.

require 'spec_helper'

require 'shared_contexts/fake_tox_network'

RSpec.configure do |config|
  config.include SharedContexts::FakeToxNetwork
end
