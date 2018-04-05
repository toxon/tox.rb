# frozen_string_literal: true

RSpec.describe Tox::Version do
  describe '::GEM_VERSION' do
    specify do
      expect(described_class::GEM_VERSION).to match(/\A(\d+)\.(\d+)\.(\d+)\z/)
    end
  end

  describe '::API_VERSION' do
    specify do
      expect(described_class::API_VERSION).to eq [
        described_class::API_MAJOR,
        described_class::API_MINOR,
        described_class::API_PATCH,
      ].join '.'
    end

    specify do
      expect(described_class::API_VERSION).to be_frozen
    end
  end

  describe '::API_MAJOR' do
    specify do
      expect(described_class::API_MAJOR).to be_kind_of Integer
    end
  end

  describe '::API_MINOR' do
    specify do
      expect(described_class::API_MINOR).to be_kind_of Integer
    end
  end

  describe '::API_PATCH' do
    specify do
      expect(described_class::API_PATCH).to be_kind_of Integer
    end
  end

  describe '.abi_version' do
    specify do
      expect(described_class.abi_version).to eq [
        described_class.abi_major,
        described_class.abi_minor,
        described_class.abi_patch,
      ].join '.'
    end

    specify do
      expect(described_class.abi_version).to be_frozen
    end
  end

  describe '.abi_major' do
    specify do
      expect(described_class.abi_major).to be_kind_of Integer
    end
  end

  describe '.abi_minor' do
    specify do
      expect(described_class.abi_minor).to be_kind_of Integer
    end
  end

  describe '.abi_patch' do
    specify do
      expect(described_class.abi_patch).to be_kind_of Integer
    end
  end
end
