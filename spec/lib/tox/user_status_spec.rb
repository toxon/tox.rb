# frozen_string_literal: true

RSpec.describe Tox::UserStatus do
  describe '::NONE' do
    specify do
      expect(described_class::NONE).to eq :none
    end
  end

  describe '::AWAY' do
    specify do
      expect(described_class::AWAY).to eq :away
    end
  end

  describe '::BUSY' do
    specify do
      expect(described_class::BUSY).to eq :busy
    end
  end
end
