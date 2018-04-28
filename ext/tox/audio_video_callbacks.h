void on_call(
  ToxAV *tox_av,
  uint32_t friend_number_data,
  bool audio_enabled_data,
  bool video_enabled_data,
  VALUE self
);

void on_audio_frame(
  ToxAV *tox_av,
  uint32_t friend_number_data,
  const uint16_t *pcm_data,
  size_t sample_count_data,
  uint8_t channels_data,
  uint32_t sampling_rate_data,
  VALUE self
);
