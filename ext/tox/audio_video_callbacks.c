#include "tox.h"

/******************************************************************************
 * Callbacks
 ******************************************************************************/

void on_call(
  ToxAV *const tox_av,
  const uint32_t friend_number_data,
  const bool audio_enabled_data,
  const bool video_enabled_data,
  const VALUE self
)
{
  const VALUE ivar_on_call = rb_iv_get(self, "@on_call");

  if (Qnil == ivar_on_call) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE audio_enabled = audio_enabled_data ? Qtrue : Qfalse;
  const VALUE video_enabled = video_enabled_data ? Qtrue : Qfalse;

  const VALUE friend_call_request = rb_funcall(
    mTox_cFriendCallRequest,
    rb_intern("new"),
    4,
    self,
    friend_number,
    audio_enabled,
    video_enabled
  );

  rb_funcall(
    ivar_on_call,
    rb_intern("call"),
    1,
    friend_call_request
  );
}

void on_call_state_change(
  ToxAV *const tox_av,
  const uint32_t friend_number_data,
  const uint32_t state_data,
  const VALUE self
)
{
  const VALUE ivar_on_call_state_change =
    rb_iv_get(self, "@on_call_state_change");

  if (Qnil == ivar_on_call_state_change) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend_call = rb_funcall(
    mTox_cFriendCall,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE state_value = UINT2NUM(state_data);

  const VALUE state = rb_funcall(
    mTox_cFriendCallState,
    rb_intern("new"),
    1,
    state_value
  );

  rb_funcall(
    ivar_on_call_state_change,
    rb_intern("call"),
    2,
    friend_call,
    state
  );
}

void on_audio_frame(
  ToxAV *const tox_av,
  const uint32_t friend_number_data,
  const uint16_t *const pcm_data,
  const size_t sample_count_data,
  const uint8_t channels_data,
  const uint32_t sampling_rate_data,
  const VALUE self
)
{
  const VALUE ivar_on_audio_frame = rb_iv_get(self, "@on_audio_frame");

  if (Qnil == ivar_on_audio_frame) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend_call = rb_funcall(
    mTox_cFriendCall,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE audio_frame = rb_funcall(mTox_cAudioFrame, rb_intern("new"), 0);

  CDATA(audio_frame, mTox_cAudioFrame_CDATA, audio_frame_cdata);

  const VALUE pcm = rb_str_new(
    pcm_data,
    sample_count_data * channels_data * (sizeof(uint16_t) / sizeof(char))
  );

  rb_iv_set(audio_frame, "@pcm", pcm);

  audio_frame_cdata->sample_count  = sample_count_data;
  audio_frame_cdata->channels      = channels_data;
  audio_frame_cdata->sampling_rate = sampling_rate_data;

  rb_funcall(
    ivar_on_audio_frame,
    rb_intern("call"),
    2,
    friend_call,
    audio_frame
  );
}

void on_video_frame(
  ToxAV *const tox_av,
  const uint32_t friend_number_data,
  const uint16_t width_data,
  const uint16_t height_data,
  const uint8_t *const y_data,
  const uint8_t *const u_data,
  const uint8_t *const v_data,
  int32_t ystride_data,
  int32_t ustride_data,
  int32_t vstride_data,
  const VALUE self
)
{
  const VALUE ivar_on_video_frame = rb_iv_get(self, "@on_video_frame");

  if (Qnil == ivar_on_video_frame) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend_call = rb_funcall(
    mTox_cFriendCall,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE video_frame = rb_funcall(mTox_cVideoFrame, rb_intern("new"), 0);

  CDATA(video_frame, mTox_cVideoFrame_CDATA, video_frame_cdata);

  video_frame_cdata->width  = width_data;
  video_frame_cdata->height = height_data;

  ystride_data = abs(ystride_data);
  ustride_data = abs(ustride_data);
  vstride_data = abs(vstride_data);

  if (ystride_data < width_data || ustride_data < width_data / 2 || vstride_data < width_data / 2) {
    // WTF?
    return;
  }

  const VALUE y_plane = rb_str_new("", 0);
  const VALUE u_plane = rb_str_new("", 0);
  const VALUE v_plane = rb_str_new("", 0);

  rb_str_resize(y_plane, width_data * height_data);
  rb_str_resize(u_plane, width_data * height_data / 4);
  rb_str_resize(v_plane, width_data * height_data / 4);

  char *const y_plane_data = RSTRING_PTR(y_plane);
  char *const u_plane_data = RSTRING_PTR(u_plane);
  char *const v_plane_data = RSTRING_PTR(v_plane);

  for (size_t h = 0; h < height_data; ++h) {
    memcpy(&y_plane_data[h * width_data], &y_data[h * ystride_data], width_data);
  }

  for (size_t h = 0; h < height_data / 2; ++h) {
    memcpy(&u_plane_data[h * width_data / 2], &u_data[h * ustride_data], width_data / 2);
    memcpy(&v_plane_data[h * width_data / 2], &v_data[h * vstride_data], width_data / 2);
  }

  rb_iv_set(video_frame, "@y_plane", y_plane);
  rb_iv_set(video_frame, "@u_plane", u_plane);
  rb_iv_set(video_frame, "@v_plane", v_plane);

  rb_funcall(
    ivar_on_video_frame,
    rb_intern("call"),
    2,
    friend_call,
    video_frame
  );
}
