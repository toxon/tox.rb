# frozen_string_literal: true

RSpec.describe Tox::AudioVideo do
  subject { described_class.new client }

  let(:client) { Tox::Client.new }

  describe '#initialize' do
    context 'when client is nil' do
      let(:client) { nil }

      specify do
        expect { subject }.to \
          raise_error(
            TypeError,
            'Expected method Tox::AudioVideo#initialize_with ' \
              'argument "client" '                             \
              "to be a #{Tox::Client}",
          )
      end
    end

    context 'when client has invalid type' do
      let(:client) { :foobar }

      specify do
        expect { subject }.to \
          raise_error(
            TypeError,
            'Expected method Tox::AudioVideo#initialize_with ' \
              'argument "client" '                             \
              "to be a #{Tox::Client}",
          )
      end
    end

    context 'when client already has audio/video instance' do
      before do
        described_class.new client
      end

      specify do
        expect { subject }.to \
          raise_error(
            RuntimeError,
            'toxav_new() failed with TOXAV_ERR_NEW_MULTIPLE',
          )
      end
    end
  end

  describe '#pointer' do
    specify do
      expect(subject.pointer).to be_kind_of Integer
    end

    specify do
      expect(subject.pointer).to be > 0
    end
  end

  describe '#iteration_interval' do
    specify do
      expect(subject.iteration_interval).to be_instance_of Float
    end

    specify do
      expect(subject.iteration_interval).to be >= 0
    end
  end

  describe '#iterate' do
    specify do
      expect(subject.iterate).to eq nil
    end
  end
end
