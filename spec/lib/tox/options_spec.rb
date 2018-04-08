# frozen_string_literal: true

RSpec.describe Tox::Options do
  subject { described_class.new }

  it { is_expected.not_to respond_to :proxy_port_internal= }
  it { is_expected.not_to respond_to :start_port_internal= }
  it { is_expected.not_to respond_to :end_port_internal=   }
  it { is_expected.not_to respond_to :tcp_port_internal=   }

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

  describe '#proxy_type' do
    it 'returns NONE by default' do
      expect(subject.proxy_type).to eq Tox::ProxyType::NONE
    end

    context 'when it was set to NONE' do
      before do
        subject.proxy_type = Tox::ProxyType::HTTP
        subject.proxy_type = Tox::ProxyType::NONE
      end

      it 'returns given value' do
        expect(subject.proxy_type).to eq Tox::ProxyType::NONE
      end
    end

    context 'when it was set to HTTP' do
      before do
        subject.proxy_type = Tox::ProxyType::HTTP
      end

      it 'returns given value' do
        expect(subject.proxy_type).to eq Tox::ProxyType::HTTP
      end
    end

    context 'when it was set to SOCKS5' do
      before do
        subject.proxy_type = Tox::ProxyType::SOCKS5
      end

      it 'returns given value' do
        expect(subject.proxy_type).to eq Tox::ProxyType::SOCKS5
      end
    end
  end

  describe '#proxy_type=' do
    context 'when invalid value given' do
      specify do
        expect { subject.proxy_type = :foobar }.to \
          raise_error ArgumentError, "Invalid value from #{Tox::ProxyType}"
      end
    end
  end

  describe '#proxy_host' do
    let(:proxy_host) { '127.0.0.1' }

    it 'returns nil by default' do
      expect(subject.proxy_host).to eq nil
    end

    context 'when it was set to some value' do
      before do
        subject.proxy_host = proxy_host
      end

      it 'returns given value' do
        expect(subject.proxy_host).to eq proxy_host
      end
    end

    context 'when it was set to nil' do
      before do
        subject.proxy_host = proxy_host
        subject.proxy_host = nil
      end

      it 'returns nil' do
        expect(subject.proxy_host).to eq nil
      end
    end

    context 'when it was set to empty string' do
      before do
        subject.proxy_host = proxy_host
        subject.proxy_host = ''
      end

      it 'returns nil' do
        expect(subject.proxy_host).to eq nil
      end
    end

    context 'when it was set to string beginning with zero byte' do
      before do
        subject.proxy_host = proxy_host
        subject.proxy_host = "\x00111.222.333.444"
      end

      it 'returns nil' do
        expect(subject.proxy_host).to eq nil
      end
    end
  end

  describe '#proxy_host=' do
    context 'when value has invalid type' do
      specify do
        expect { subject.proxy_host = :foobar }.to raise_error(
          TypeError,
          "wrong argument type #{Symbol} (expected #{String})",
        )
      end
    end

    context 'when value is too long' do
      specify do
        expect { subject.proxy_host = 'a' * 256 }.to \
          raise_error(
            RuntimeError,
            'Proxy host string can not be longer than 255 bytes',
          )
      end
    end
  end

  describe '#proxy_port' do
    it 'returns default value' do
      expect(subject.proxy_port).to eq 0
    end

    context 'when it was set to some value' do
      before do
        subject.proxy_port = proxy_port
      end

      let(:proxy_port) { rand 1..65_535 }

      it 'returns given value' do
        expect(subject.proxy_port).to eq proxy_port
      end
    end
  end

  describe '#proxy_port=' do
    context 'when value has invalid type' do
      specify do
        expect { subject.proxy_port = :foobar }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{Symbol}",
        )
      end
    end

    context 'when value is zero' do
      specify do
        expect { subject.proxy_port = 0 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 1..65535',
        )
      end
    end

    context 'when value is greater than 65`535' do
      specify do
        expect { subject.proxy_port = 65_536 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 1..65535',
        )
      end
    end
  end

  describe '#start_port' do
    it 'returns default value' do
      expect(subject.start_port).to eq 0
    end

    context 'when it was set to some value' do
      before do
        subject.start_port = start_port
      end

      let(:start_port) { rand 1..65_535 }

      it 'returns given value' do
        expect(subject.start_port).to eq start_port
      end
    end

    context 'when it was set to zero' do
      before do
        subject.start_port = 0
      end

      it 'returns zero' do
        expect(subject.start_port).to eq 0
      end
    end
  end

  describe '#start_port=' do
    context 'when value has invalid type' do
      specify do
        expect { subject.start_port = :foobar }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{Symbol}",
        )
      end
    end

    context 'when value is less than zero' do
      specify do
        expect { subject.start_port = -1 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end

    context 'when value is greater than 65`535' do
      specify do
        expect { subject.start_port = 65_536 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end
  end

  describe '#end_port' do
    it 'returns default value' do
      expect(subject.end_port).to eq 0
    end

    context 'when it was set to some value' do
      before do
        subject.end_port = end_port
      end

      let(:end_port) { rand 1..65_535 }

      it 'returns given value' do
        expect(subject.end_port).to eq end_port
      end
    end

    context 'when it was set to zero' do
      before do
        subject.end_port = 0
      end

      it 'returns zero' do
        expect(subject.end_port).to eq 0
      end
    end
  end

  describe '#end_port=' do
    context 'when value has invalid type' do
      specify do
        expect { subject.end_port = :foobar }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{Symbol}",
        )
      end
    end

    context 'when value is less than zero' do
      specify do
        expect { subject.end_port = -1 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end

    context 'when value is greater than 65`535' do
      specify do
        expect { subject.end_port = 65_536 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end
  end

  describe '#tcp_port' do
    it 'returns default value' do
      expect(subject.tcp_port).to eq 0
    end

    context 'when it was set to some value' do
      before do
        subject.tcp_port = tcp_port
      end

      let(:tcp_port) { rand 1..65_535 }

      it 'returns given value' do
        expect(subject.tcp_port).to eq tcp_port
      end
    end

    context 'when it was set to zero' do
      before do
        subject.tcp_port = 0
      end

      it 'returns zero' do
        expect(subject.tcp_port).to eq 0
      end
    end
  end

  describe '#tcp_port=' do
    context 'when value has invalid type' do
      specify do
        expect { subject.tcp_port = :foobar }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{Symbol}",
        )
      end
    end

    context 'when value is less than zero' do
      specify do
        expect { subject.tcp_port = -1 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end

    context 'when value is greater than 65`535' do
      specify do
        expect { subject.tcp_port = 65_536 }.to raise_error(
          RuntimeError,
          'Expected value to be from range 0..65535',
        )
      end
    end
  end
end
