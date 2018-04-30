# frozen_string_literal: true

RSpec.describe Tox::AudioFrame do
  subject { described_class.new }

  describe '#initialize' do
    specify do
      expect { subject }.not_to raise_error
    end
  end

  describe '#sample_count' do
    specify do
      expect(subject.sample_count).to be_kind_of Integer
    end
  end

  describe '#channels' do
    specify do
      expect(subject.channels).to be_kind_of Integer
    end
  end

  describe '#sampling_rate' do
    specify do
      expect(subject.sampling_rate).to be_kind_of Integer
    end
  end
end
