# frozen_string_literal: true

RSpec.describe Tox::FileKind do
  describe '::DATA' do
    specify do
      expect(described_class::DATA).to eq :data
    end
  end

  describe '::AVATAR' do
    specify do
      expect(described_class::AVATAR).to eq :avatar
    end
  end
end
