# frozen_string_literal: true

RSpec.describe Tox::FileControl do
  describe '::RESUME' do
    specify do
      expect(described_class::RESUME).to eq :resume
    end
  end

  describe '::PAUSE' do
    specify do
      expect(described_class::PAUSE).to eq :pause
    end
  end

  describe '::CANCEL' do
    specify do
      expect(described_class::CANCEL).to eq :cancel
    end
  end
end
