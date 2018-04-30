#include "tox.h"

// Public methods

static VALUE mTox_cFriendCall_send_audio_frame(VALUE self, VALUE audio_frame);
static VALUE mTox_cFriendCall_send_video_frame(VALUE self, VALUE video_frame);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriendCall_INIT()
{
  // Public methods

  rb_define_method(mTox_cFriendCall, "send_audio_frame", mTox_cFriendCall_send_audio_frame, 1);
  rb_define_method(mTox_cFriendCall, "send_video_frame", mTox_cFriendCall_send_video_frame, 1);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::FriendCall#send_audio_frame
VALUE mTox_cFriendCall_send_audio_frame(
  const VALUE self,
  const VALUE audio_frame
)
{
  if (!rb_funcall(audio_frame, rb_intern("is_a?"), 1, mTox_cAudioFrame)) {
    RAISE_TYPECHECK(
      "Tox::FriendCall#send_audio_frame",
      "audio_frame",
      "Tox::AudioFrame"
    );
  }

  const VALUE audio_video   = rb_iv_get(self, "@audio_video");
  const VALUE friend_number = rb_iv_get(self, "@friend_number");

  const uint32_t friend_number_data = NUM2ULONG(friend_number);

  const VALUE pcm = rb_iv_get(audio_frame, "@pcm");

  const char *const pcm_data = RSTRING_PTR(pcm);

  CDATA(audio_video, mTox_cAudioVideo_CDATA, audio_video_cdata);
  CDATA(audio_frame, mTox_cAudioFrame_CDATA, audio_frame_cdata);

  TOXAV_ERR_SEND_FRAME toxav_audio_send_frame_error;

  const bool toxav_audio_send_frame_result = toxav_audio_send_frame(
    audio_video_cdata->tox_av,
    friend_number_data,
    pcm_data,
    audio_frame_cdata->sample_count,
    audio_frame_cdata->channels,
    audio_frame_cdata->sampling_rate,
    &toxav_audio_send_frame_error
  );

  switch (toxav_audio_send_frame_error) {
    case TOXAV_ERR_SEND_FRAME_OK:
      break;
    case TOXAV_ERR_SEND_FRAME_NULL:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_NULL"
      );
    case TOXAV_ERR_SEND_FRAME_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_FRIEND_NOT_FOUND"
      );
    case TOXAV_ERR_SEND_FRAME_FRIEND_NOT_IN_CALL:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_FRIEND_NOT_IN_CALL"
      );
    case TOXAV_ERR_SEND_FRAME_SYNC:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_SYNC"
      );
    case TOXAV_ERR_SEND_FRAME_INVALID:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_INVALID"
      );
    case TOXAV_ERR_SEND_FRAME_PAYLOAD_TYPE_DISABLED:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_PAYLOAD_TYPE_DISABLED"
      );
    case TOXAV_ERR_SEND_FRAME_RTP_FAILED:
      RAISE_FUNC_ERROR(
        "toxav_audio_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_RTP_FAILED"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("toxav_audio_send_frame");
  }

  if (!toxav_audio_send_frame_result) {
    RAISE_FUNC_RESULT("toxav_audio_send_frame");
  }

  return Qnil;
}

// Tox::FriendCall#send_video_frame
VALUE mTox_cFriendCall_send_video_frame(
  const VALUE self,
  const VALUE video_frame
)
{
  if (!rb_funcall(video_frame, rb_intern("is_a?"), 1, mTox_cVideoFrame)) {
    RAISE_TYPECHECK(
      "Tox::FriendCall#send_video_frame",
      "video_frame",
      "Tox::VideoFrame"
    );
  }

  const VALUE audio_video   = rb_iv_get(self, "@audio_video");
  const VALUE friend_number = rb_iv_get(self, "@friend_number");

  const uint32_t friend_number_data = NUM2ULONG(friend_number);

  CDATA(audio_video, mTox_cAudioVideo_CDATA, audio_video_cdata);
  CDATA(video_frame, mTox_cVideoFrame_CDATA, video_frame_cdata);

  TOXAV_ERR_SEND_FRAME toxav_video_send_frame_error;

  const bool toxav_video_send_frame_result = toxav_video_send_frame(
    audio_video_cdata->tox_av,
    friend_number_data,
    video_frame_cdata->width,
    video_frame_cdata->height,
    video_frame_cdata->y,
    video_frame_cdata->u,
    video_frame_cdata->v,
    &toxav_video_send_frame_error
  );

  switch (toxav_video_send_frame_error) {
    case TOXAV_ERR_SEND_FRAME_OK:
      break;
    case TOXAV_ERR_SEND_FRAME_NULL:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_NULL"
      );
    case TOXAV_ERR_SEND_FRAME_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_FRIEND_NOT_FOUND"
      );
    case TOXAV_ERR_SEND_FRAME_FRIEND_NOT_IN_CALL:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_FRIEND_NOT_IN_CALL"
      );
    case TOXAV_ERR_SEND_FRAME_SYNC:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_SYNC"
      );
    case TOXAV_ERR_SEND_FRAME_INVALID:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_INVALID"
      );
    case TOXAV_ERR_SEND_FRAME_PAYLOAD_TYPE_DISABLED:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_PAYLOAD_TYPE_DISABLED"
      );
    case TOXAV_ERR_SEND_FRAME_RTP_FAILED:
      RAISE_FUNC_ERROR(
        "toxav_video_send_frame",
        rb_eRuntimeError,
        "TOXAV_ERR_SEND_FRAME_RTP_FAILED"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("toxav_video_send_frame");
  }

  if (!toxav_video_send_frame_result) {
    RAISE_FUNC_RESULT("toxav_video_send_frame");
  }

  return Qnil;
}
