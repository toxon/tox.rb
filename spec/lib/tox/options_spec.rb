# frozen_string_literal: true

RSpec.describe Tox::Options do
  subject { described_class.new }

  describe '#savedata' do
    it 'returns nil by default' do
      expect(subject.savedata).to eq nil
    end

    context 'when it was set to byte string' do
      let(:savedata) { SecureRandom.random_bytes(100).freeze }

      before do
        subject.savedata = savedata
      end

      it 'returns given string' do
        expect(subject.savedata).to eq savedata
      end
    end

    context 'when it was set to something and then to nil' do
      before do
        subject.savedata = SecureRandom.random_bytes(100).freeze
        subject.savedata = nil
      end

      it 'returns nil' do
        expect(subject.savedata).to eq nil
      end
    end
  end

  describe '#savedata=' do
    context 'when called by #public_send with nil' do
      it 'returns nil' do
        expect(subject.public_send(:savedata=, nil)).to eq nil
      end
    end

    context 'when called by #public_send with string' do
      let(:savedata) { SecureRandom.random_bytes(100).freeze }

      it 'returns given string' do
        expect(subject.public_send(:savedata=, savedata)).to eq savedata
      end
    end
  end

  describe '#ipv6_enabled' do
    it 'returns true by default' do
      expect(subject.ipv6_enabled).to eq true
    end

    context 'when it was set to false' do
      before do
        subject.ipv6_enabled = false
      end

      it 'returns given value' do
        expect(subject.ipv6_enabled).to eq false
      end
    end

    context 'when it was set to true' do
      before do
        subject.ipv6_enabled = false
        subject.ipv6_enabled = true
      end

      it 'returns given value' do
        expect(subject.ipv6_enabled).to eq true
      end
    end
  end

  describe '#udp_enabled' do
    it 'returns true by default' do
      expect(subject.udp_enabled).to eq true
    end

    context 'when it was set to false' do
      before do
        subject.udp_enabled = false
      end

      it 'returns given value' do
        expect(subject.udp_enabled).to eq false
      end
    end

    context 'when it was set to true' do
      before do
        subject.udp_enabled = false
        subject.udp_enabled = true
      end

      it 'returns given value' do
        expect(subject.udp_enabled).to eq true
      end
    end
  end

  describe '#local_discovery_enabled' do
    it 'returns true by default' do
      expect(subject.local_discovery_enabled).to eq true
    end

    context 'when it was set to false' do
      before do
        subject.local_discovery_enabled = false
      end

      it 'returns given value' do
        expect(subject.local_discovery_enabled).to eq false
      end
    end

    context 'when it was set to true' do
      before do
        subject.local_discovery_enabled = false
        subject.local_discovery_enabled = true
      end

      it 'returns given value' do
        expect(subject.local_discovery_enabled).to eq true
      end
    end
  end
end
