# frozen_string_literal: true

module Tox
  ##
  # Audio frame.
  #
  class AudioFrame
    VALID_SAMPLING_RATES = [8_000, 12_000, 16_000, 24_000, 48_000].freeze

    attr_accessor :pcm

    def initialize
      @pcm = ''
    end

    def valid?
      VALID_SAMPLING_RATES.include?(sampling_rate) && pcm.is_a?(String) &&
        pcm.length == sample_count * channels * 2
    end
  end
end
