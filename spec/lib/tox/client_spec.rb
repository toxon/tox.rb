# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Client do
  describe '#savedata' do
    it 'can be set via options' do
      tox1_options = Tox::Options.new
      tox1_client = Tox::Client.new tox1_options

      savedata = tox1_client.savedata

      tox2_options = Tox::Options.new
      tox2_options.savedata = savedata
      tox2_client = Tox::Client.new tox2_options

      expect(tox2_client.savedata).to eq savedata
    end
  end
end
