# frozen_string_literal: true

RSpec.describe 'lib/gst-plugins-tox.so' do
  subject { Gst::Registry.get.find_plugin 'tox' }

  describe '#description' do
    specify do
      expect(subject.description).to eq 'Tox audio/video sink/src'
    end
  end

  describe '#license' do
    specify do
      expect(subject.license).to eq 'GPL'
    end
  end

  describe '#name' do
    specify do
      expect(subject.name).to eq 'tox'
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
      expect(subject.source).to eq 'tox'
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
