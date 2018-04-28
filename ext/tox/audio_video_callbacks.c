#include "tox.h"

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

  const VALUE friend_call_request = rb_funcall(
    mTox_cFriendCallRequest,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE audio_enabled = audio_enabled_data ? Qtrue : Qfalse;
  const VALUE video_enabled = video_enabled_data ? Qtrue : Qfalse;

  rb_funcall(
    ivar_on_call,
    rb_intern("call"),
    3,
    friend_call_request,
    audio_enabled,
    video_enabled
  );
}

void on_call_state_change(
  ToxAV *const tox_av,
  const uint32_t friend_number_data,
  const uint32_t friend_call_state_data,
  const VALUE self
)
{
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

  audio_frame_cdata->pcm           = pcm_data;
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
