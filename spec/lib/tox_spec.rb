# frozen_string_literal: true

require 'tox'

RSpec.describe Tox do
  describe '::VERSION' do
    specify do
      expect(described_class::VERSION).to match(/\A(\d+)\.(\d+)\.(\d+)\z/)
    end
  end

  describe '#savedata' do
    it 'can be set via options' do
      tox1_options = Tox::Options.new
      tox1 = Tox.new tox1_options

      savedata = tox1.savedata

      tox2_options = Tox::Options.new
      tox2_options.savedata = savedata
      tox2 = Tox.new tox2_options

      expect(tox2.savedata).to eq savedata
    end
  end
end
