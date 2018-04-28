# frozen_string_literal: true

module Tox
  ##
  # Tox audio/video instance.
  #
  class AudioVideo
    def initialize(client)
      @on_call = nil
      @on_audio_frame = nil

      initialize_with client
    end

    def on_call(&block)
      @on_call = block
    end

    def on_audio_frame(&block)
      @on_audio_frame = block
    end
  end
end
