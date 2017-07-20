# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::PublicKey do
  subject { described_class.new hex }

  let(:hex) { SecureRandom.hex(32).upcase.freeze }

  let(:bin) { [hex].pack('H*').freeze }

  it { is_expected.to be_frozen }

  describe '.from_binary' do
    it 'creates from binary value' do
      expect(described_class.from_binary(bin)).to eq described_class.new bin, binary: true
    end
  end

  describe '#initialize' do
    context 'when binary value provided' do
      subject { described_class.new bin, binary: true }

      it { is_expected.to be_frozen }

      it 'represents it as is' do
        expect(subject).to eq bin
      end
    end
  end

  it 'equals binary value' do
    expect(subject).to eq bin
  end

  describe '#to_s' do
    it 'returns hexadecimal value' do
      expect(subject.to_hex).to eq hex
    end
  end

  describe '#inspect' do
    it 'returns inspected value' do
      expect(subject.inspect).to eq "#<#{described_class}: \"#{subject.to_hex}\">"
    end
  end
end
