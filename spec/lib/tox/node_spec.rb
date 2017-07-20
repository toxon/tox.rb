# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Node do
  subject { described_class.new public_key, port, ipv4 }

  let(:public_key) { '6FC41E2BD381D37E9748FC0E0328CE086AF9598BECC8FEB7DDF2E440475F300E' }
  let(:port) { 33_445 }
  let(:ipv4) { '51.15.37.145' }

  describe '#public_key' do
    it 'returns given value' do
      expect(subject.public_key).to eq Tox::PublicKey.new public_key
    end
  end

  describe '#port' do
    it 'returns given value' do
      expect(subject.port).to eq port
    end
  end

  describe '#ipv4' do
    it 'returns given value' do
      expect(subject.ipv4).to eq ipv4
    end
  end
end
