# frozen_string_literal: true

module Tox
  ##
  # Friend call state bit mask.
  #
  class FriendCallState
    using CoreExt

    ERROR           = 1
    FINISHED        = 2
    SENDING_AUDIO   = 4
    SENDING_VIDEO   = 8
    ACCEPTING_AUDIO = 16
    ACCEPTING_VIDEO = 32

    attr_reader :bit_mask

    def initialize(bit_mask)
      self.bit_mask = bit_mask
    end

    def error?
      bit_mask & ERROR != 0
    end

    def finished?
      bit_mask & FINISHED != 0
    end

    def sending_audio?
      bit_mask & SENDING_AUDIO != 0
    end

    def sending_video?
      bit_mask & SENDING_VIDEO != 0
    end

    def accepting_audio?
      bit_mask & ACCEPTING_AUDIO != 0
    end

    def accepting_video?
      bit_mask & ACCEPTING_VIDEO != 0
    end

  private

    def bit_mask=(value)
      Integer.ancestor_of! value
      unless value >= 0
        raise 'Expected value to be greater than or equal to zero'
      end
      @bit_mask = value
    end
  end
end
