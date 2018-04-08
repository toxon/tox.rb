# frozen_string_literal: true

RSpec.describe Tox::Proxies::SOCKS5 do
  subject { described_class.new host, port }

  let(:host) { '127.0.0.1' }
  let(:port) { rand 1..65_535 }

  describe '#initialize' do
    context 'when given host value has invalid type' do
      let(:host) { :foobar }

      specify do
        expect { subject }.to \
          raise_error TypeError, "Expected #{String}, got #{host.class}"
      end
    end

    context 'when given port value has invalid type' do
      let(:port) { 12_345.678 }

      specify do
        expect { subject }.to \
          raise_error TypeError, "Expected #{Integer}, got #{port.class}"
      end
    end

    context 'when given host value is too long' do
      let(:host) { 'a' * 256 }

      specify do
        expect { subject }.to raise_error(
          RuntimeError,
          'Proxy host string can not be longer than 255 bytes',
        )
      end
    end

    context 'when given port value is less than 1' do
      let(:port) { 0 }

      specify do
        expect { subject }.to \
          raise_error 'Expected value to be from range 1..65535'
      end
    end

    context 'when given port value is greater than 65535' do
      let(:port) { 65_536 }

      specify do
        expect { subject }.to \
          raise_error 'Expected value to be from range 1..65535'
      end
    end
  end

  describe '#host' do
    specify do
      expect(subject.host).to be_instance_of String
    end

    specify do
      expect(subject.host).to be_frozen
    end

    it 'returns given value' do
      expect(subject.host).to eq host
    end

    context 'when given values is not frozen' do
      let(:host) { +'127.0.0.1' }

      specify do
        expect(subject.host).to be_instance_of String
      end

      specify do
        expect(subject.host).to be_frozen
      end

      it 'returns given value' do
        expect(subject.host).to eq host
      end

      it 'does not freeze given object' do
        expect(host).not_to be_frozen
      end
    end
  end

  describe '#port' do
    specify do
      expect(subject.port).to be_kind_of Integer
    end

    specify do
      expect(subject.port).to eq port
    end
  end

  describe '#==' do
    let(:other) { described_class.new other_host, other_port }

    let(:other_host) { host }
    let(:other_port) { port }

    specify do
      expect(subject).to eq other
    end

    context 'when values differ by host' do
      let(:other_host) { Faker::Internet.ip_v4_address }

      specify do
        expect(subject).not_to eq other
      end
    end

    context 'when values differ by port' do
      let(:other_port) { rand 1..65_535 }

      specify do
        expect(subject).not_to eq other
      end
    end

    context 'when compared with different kind of proxy' do
      let(:other) { Tox::Proxies::HTTP.new host, port }

      specify do
        expect(subject).not_to eq other
      end
    end

    context 'when compared with subclass instance' do
      let(:other) { Class.new(described_class).new host, port }

      specify do
        expect(subject).not_to eq other
      end
    end
  end
end
