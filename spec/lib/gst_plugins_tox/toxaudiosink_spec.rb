# frozen_string_literal: true

require 'gst'

RSpec.describe 'toxaudiosink' do
  subject { registry.find_plugin 'toxaudiosink' }

  let(:registry) { Gst::Registry.get }

  before do
    registry.scan_path File.expand_path '../../../lib', __dir__
  end

  describe '#description' do
    specify do
      expect(subject.description).to eq 'Sends Opus audio to Tox'
    end
  end

  describe '#license' do
    specify do
      expect(subject.license).to eq 'GPL'
    end
  end

  describe '#name' do
    specify do
      expect(subject.name).to eq 'toxaudiosink'
    end
  end

  describe '#origin' do
    specify do
      expect(subject.origin).to eq 'https://github.com/toxon/tox.rb'
    end
  end

  describe '#package' do
    specify do
      expect(subject.package).to eq 'gst-plugins-tox'
    end
  end

  describe '#source' do
    specify do
      expect(subject.source).to eq 'toxaudiosink'
    end
  end

  describe '#version' do
    specify do
      expect(subject.version).to eq '0.0.0'
    end
  end

  describe '#load' do
    specify do
      expect { subject.load }.not_to raise_error
    end
  end
end
