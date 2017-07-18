# frozen_string_literal: true

require 'tox'

RSpec.describe Tox do
  describe '::VERSION' do
    specify do
      expect(described_class::VERSION).to match(/\A(\d+)\.(\d+)\.(\d+)\z/)
    end
  end
end
