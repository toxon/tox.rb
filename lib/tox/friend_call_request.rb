# frozen_string_literal: true

module Tox
  ##
  # Friend call request.
  #
  class FriendCallRequest
    attr_reader :audio_video, :friend_number

    def initialize(audio_video, friend_number)
      self.audio_video   = audio_video
      self.friend_number = friend_number
    end

    def ==(other)
      self.class == other.class &&
        audio_video == other.audio_video &&
        friend_number == other.friend_number
    end

  private

    def audio_video=(value)
      unless value.is_a? AudioVideo
        raise TypeError, "Expected #{AudioVideo}, got #{value.class}"
      end
      @audio_video = value
    end

    def friend_number=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless value >= 0
        raise 'Expected value to be greater than or equal to zero'
      end
      @friend_number = value
    end
  end
end
