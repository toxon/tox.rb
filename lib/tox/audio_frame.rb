# frozen_string_literal: true

module Tox
  ##
  # Audio frame.
  #
  class AudioFrame
    attr_accessor :pcm

    def initialize
      @pcm = ''
    end
  end
end
