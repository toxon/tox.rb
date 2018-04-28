# frozen_string_literal: true

RSpec.describe Tox::FriendCallRequest do
  subject do
    described_class.new audio_video, friend_number, audio_enabled, video_enabled
  end

  let(:audio_video) { Tox::AudioVideo.new client }

  let(:friend_number) { rand 0..10 }

  let(:audio_enabled) { [false, true].sample }
  let(:video_enabled) { [false, true].sample }

  let(:client) { Tox::Client.new }

  describe '#initialize' do
    context 'when audio/video has invalid type' do
      let(:audio_video) { :foobar }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Tox::AudioVideo}, got #{audio_video.class}",
        )
      end
    end

    context 'when friend number has invalid tyoe' do
      let(:friend_number) { :foobar }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{friend_number.class}",
        )
      end
    end

    context 'when friend number is less than zero' do
      let(:friend_number) { -1 }

      specify do
        expect { subject }.to raise_error(
          RuntimeError,
          'Expected value to be greater than or equal to zero',
        )
      end
    end
  end

  describe '#audio_video' do
    specify do
      expect(subject.audio_video).to be_instance_of Tox::AudioVideo
    end

    specify do
      expect(subject.audio_video).to equal audio_video
    end
  end

  describe '#friend_number' do
    specify do
      expect(subject.friend_number).to be_a Integer
    end

    specify do
      expect(subject.friend_number).to eq friend_number
    end
  end

  describe '#audio_enabled?' do
    specify do
      expect(subject.audio_enabled?).to eq audio_enabled
    end
  end

  describe '#video_enabled?' do
    specify do
      expect(subject.video_enabled?).to eq video_enabled
    end
  end

  describe '#==' do
    let :same_friend do
      described_class.new audio_video, friend_number,
                          audio_enabled, video_enabled
    end

    let :with_other_audio_video do
      described_class.new other_audio_video, friend_number,
                          audio_enabled, video_enabled
    end

    let :with_other_friend_number do
      described_class.new audio_video, other_friend_number,
                          audio_enabled, video_enabled
    end

    let(:other_audio_video) { Tox::AudioVideo.new Tox::Client.new }
    let(:other_friend_number) { rand 200..300 }

    it 'returns true when compared to itself' do
      expect(subject).to eq subject
    end

    it 'returns true when values are equal' do
      expect(subject).to eq same_friend
    end

    it 'returns false when audio/video differs' do
      expect(subject).not_to eq with_other_audio_video
    end

    it 'returns false when friend number differs' do
      expect(subject).not_to eq with_other_friend_number
    end

    it 'returns false when compared with subclass instance' do
      expect(subject).not_to eq Class.new(described_class).new(
        audio_video,
        friend_number,
        audio_enabled,
        video_enabled,
      )
    end
  end
end
