# frozen_string_literal: true

module Tox
  ##
  # Audio frame.
  #
  class AudioFrame
    using CoreExt

    VALID_SAMPLING_RATES = [8_000, 12_000, 16_000, 24_000, 48_000].freeze
    VALID_AUDIO_LENGTHS  = [2.5, 5, 10, 20, 40, 60].freeze

    attr_reader :pcm

    def initialize
      @pcm = ''
    end

    def pcm=(value)
      String.ancestor_of! value
      @pcm = value
    end

    def valid?
      VALID_SAMPLING_RATES.include?(sampling_rate) &&
        sample_count_valid? &&
        pcm_size_valid?
    end

  private

    def sample_count_valid?
      VALID_AUDIO_LENGTHS.any? do |audio_length|
        sample_count == sampling_rate * audio_length / 1000
      end
    end

    def pcm_size_valid?
      pcm.bytesize == sample_count * channels * 2
    end
  end
end
