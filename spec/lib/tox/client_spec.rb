# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Client do
  describe '#savedata' do
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
