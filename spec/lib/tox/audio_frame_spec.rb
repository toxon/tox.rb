# frozen_string_literal: true

RSpec.describe Tox::AudioFrame do
  subject { described_class.new }

  before do
    subject.pcm           = pcm           if pcm
    subject.sample_count  = sample_count  if sample_count
    subject.channels      = channels      if channels
    subject.sampling_rate = sampling_rate if sampling_rate
  end

  let(:pcm)           { nil }
  let(:sample_count)  { nil }
  let(:channels)      { nil }
  let(:sampling_rate) { nil }

  describe '#initialize' do
    specify do
      expect { subject }.not_to raise_error
    end
  end

  describe '#pcm' do
    specify do
      expect(subject.pcm).to be_instance_of String
    end

    specify do
      expect(subject.pcm).to eq ''
    end

    context 'when it was set' do
      let(:pcm) { SecureRandom.random_bytes rand 0..10 }

      specify do
        expect(subject.pcm).to eq pcm
      end
    end
  end

  describe '#sample_count' do
    specify do
      expect(subject.sample_count).to be_kind_of Integer
    end

    specify do
      expect(subject.sample_count).to eq 0
    end

    context 'when it was set to positive value' do
      let(:sample_count) { rand 0...(2**31 - 1) }

      specify do
        expect(subject.sample_count).to eq sample_count
      end
    end

    context 'when it was set to negative value' do
      let(:sample_count) { rand((-2**31)...0) }

      specify do
        expect(subject.sample_count).to eq sample_count
      end
    end
  end

  describe '#channels' do
    specify do
      expect(subject.channels).to be_kind_of Integer
    end

    specify do
      expect(subject.channels).to eq 0
    end

    context 'when it was set to positive value' do
      let(:channels) { rand 0...(2**8 - 1) }

      specify do
        expect(subject.channels).to eq channels
      end
    end

    context 'when it was set to negative value' do
      let(:channels) { rand((-2**8 + 1)...0) }

      specify do
        expect(subject.channels).to eq 2**8 - -channels
      end
    end
  end

  describe '#sampling_rate' do
    specify do
      expect(subject.sampling_rate).to be_kind_of Integer
    end

    specify do
      expect(subject.sampling_rate).to eq 0
    end

    context 'when it was set to positive value' do
      let(:sampling_rate) { rand 0...(2**32 - 1) }

      specify do
        expect(subject.sampling_rate).to eq sampling_rate
      end
    end

    context 'when it was set to negative value' do
      let(:sampling_rate) { rand((-2**31)...0) }

      specify do
        expect(subject.sampling_rate).to eq 2**32 - -sampling_rate
      end
    end
  end
end
