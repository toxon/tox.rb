# frozen_string_literal: true

RSpec.describe Tox do
  describe '.hash' do
    it 'returns proper hash for empty string' do
      expect(described_class.hash('')).to eq OpenSSL::Digest::SHA256.digest ''
    end

    specify do
      expect(described_class.hash('abc')).to \
        eq OpenSSL::Digest::SHA256.digest 'abc'
    end

    specify do
      s = 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'
      expect(described_class.hash(s)).to eq OpenSSL::Digest::SHA256.digest s
    end

    specify do
      expect(described_class.hash('aaaaaaaaaa')).to \
        eq OpenSSL::Digest::SHA256.digest 'aaaaaaaaaa'
    end

    context 'for random small data' do
      let(:data) { SecureRandom.random_bytes rand 10...100 }

      specify do
        expect(described_class.hash(data)).to \
          eq OpenSSL::Digest::SHA256.digest data
      end
    end

    context 'for random large data' do
      let(:data) { SecureRandom.random_bytes rand 100_000...1_000_000 }

      specify do
        expect(described_class.hash(data)).to \
          eq OpenSSL::Digest::SHA256.digest data
      end
    end
  end
end
