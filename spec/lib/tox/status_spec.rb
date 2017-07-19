# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Status do
  describe '.request' do
    specify do
      expect(described_class.request(described_class::Official::URL)).to be_a described_class::JsonApiRequest
    end
  end

  describe '.official' do
    specify do
      expect(described_class.official).to be_a described_class::Official
    end
  end
end
