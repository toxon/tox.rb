void on_call(
  ToxAV *tox_av,
  uint32_t friend_number_data,
  bool audio_enabled_data,
  bool video_enabled_data,
  VALUE self
);

void on_call_state_change(
  ToxAV *tox_av,
  uint32_t friend_number_data,
  uint32_t state_data,
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

void on_video_frame(
  ToxAV *tox_av,
  uint32_t friend_number_data,
  uint16_t width_data,
  uint16_t height_data,
  const uint8_t *y,
  const uint8_t *u,
  const uint8_t *v,
  int32_t ystride,
  int32_t ustride,
  int32_t vstride,
  VALUE self
);
