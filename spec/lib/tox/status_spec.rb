# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Status do
  describe '.official' do
    specify do
      expect(described_class.official).to be_a described_class::Official
    end
  end
end
