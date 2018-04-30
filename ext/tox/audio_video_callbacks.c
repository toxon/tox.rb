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
  const int32_t ystride_data,
  const int32_t ustride_data,
  const int32_t vstride_data,
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

  video_frame_cdata->y = y_data;
  video_frame_cdata->u = u_data;
  video_frame_cdata->v = v_data;

  rb_funcall(
    ivar_on_video_frame,
    rb_intern("call"),
    2,
    friend_call,
    video_frame
  );
}
