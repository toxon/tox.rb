# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Client do
  subject { described_class.new }

  describe '#initialize' do
    context 'when options is nil' do
      specify do
        expect { described_class.new nil }.to raise_error TypeError, "expected options to be a #{Tox::Options}"
      end
    end

    context 'when options have invalid type' do
      specify do
        expect { described_class.new 123 }.to raise_error TypeError, "expected options to be a #{Tox::Options}"
      end
    end
  end

  describe '#savedata' do
    it 'returns string by default' do
      expect(subject.savedata).to be_a String
    end

    context 'when it was set via options' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { Tox::Client.new.savedata }

      it 'can be set via options' do
        expect(subject.savedata).to eq savedata
      end
    end
  end
end
