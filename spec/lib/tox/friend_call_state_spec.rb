# frozen_string_literal: true

RSpec.describe Tox::FriendCallState do
  subject { described_class.new bit_mask }

  let :bit_mask do
    result = 0
    result |= 1  if flag_error
    result |= 2  if flag_finished
    result |= 4  if flag_sending_audio
    result |= 8  if flag_sending_video
    result |= 16 if flag_accepting_audio
    result |= 32 if flag_accepting_video
    result
  end

  let(:flag_error)           { [false, true].sample }
  let(:flag_finished)        { [false, true].sample }
  let(:flag_sending_audio)   { [false, true].sample }
  let(:flag_sending_video)   { [false, true].sample }
  let(:flag_accepting_audio) { [false, true].sample }
  let(:flag_accepting_video) { [false, true].sample }

  describe '#initialize' do
    context 'when bit mask has invalid type' do
      let(:bit_mask) { 123.456 }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{bit_mask.class}",
        )
      end
    end

    context 'when bit mask is negative' do
      let(:bit_mask) { -1 }

      specify do
        expect { subject }.to raise_error(
          RuntimeError,
          'Expected value to be greater than or equal to zero',
        )
      end
    end
  end

  describe '#error?' do
    specify do
      expect(subject.error?).to eq flag_error
    end
  end

  describe '#finished?' do
    specify do
      expect(subject.finished?).to eq flag_finished
    end
  end

  describe '#sending_audio?' do
    specify do
      expect(subject.sending_audio?).to eq flag_sending_audio
    end
  end

  describe '#sending_video?' do
    specify do
      expect(subject.sending_video?).to eq flag_sending_video
    end
  end

  describe '#accepting_audio?' do
    specify do
      expect(subject.accepting_audio?).to eq flag_accepting_audio
    end
  end

  describe '#accepting_video?' do
    specify do
      expect(subject.accepting_video?).to eq flag_accepting_video
    end
  end
end
