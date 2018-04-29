# frozen_string_literal: true

module Tox
  ##
  # Friend call request.
  #
  class FriendCallRequest
    using CoreExt

    attr_reader :audio_video, :friend_number

    def initialize(audio_video, friend_number, audio_enabled, video_enabled)
      self.audio_video   = audio_video
      self.friend_number = friend_number

      @audio_enabled = !!audio_enabled
      @video_enabled = !!video_enabled
    end

    def audio_enabled?
      @audio_enabled
    end

    def video_enabled?
      @video_enabled
    end

    def ==(other)
      self.class == other.class &&
        audio_video == other.audio_video &&
        friend_number == other.friend_number
    end

  private

    def audio_video=(value)
      AudioVideo.ancestor_of! value
      @audio_video = value
    end

    def friend_number=(value)
      Integer.ancestor_of! value
      unless value >= 0
        raise 'Expected value to be greater than or equal to zero'
      end
      @friend_number = value
    end
  end
end
