#include "tox.h"

// Public methods

static VALUE mTox_cFriendCallRequest_answer(VALUE self, VALUE audio_bit_rate, VALUE video_bit_rate);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriendCallRequest_INIT()
{
  // Public methods

  rb_define_method(mTox_cFriendCallRequest, "answer", mTox_cFriendCallRequest_answer, 2);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::FriendCallRequest#answer
VALUE mTox_cFriendCallRequest_answer(
  const VALUE self,
  const VALUE audio_bit_rate,
  const VALUE video_bit_rate
)
{
  const VALUE audio_video   = rb_iv_get(self, "@audio_video");
  const VALUE friend_number = rb_iv_get(self, "@friend_number");

  CDATA(audio_video, mTox_cAudioVideo_CDATA, audio_video_cdata);

  const uint32_t friend_number_data = NUM2ULONG(friend_number);

  const uint32_t audio_bit_rate_data =
    Qnil == audio_bit_rate ? 0 : NUM2ULONG(audio_bit_rate);

  const uint32_t video_bit_rate_data =
    Qnil == video_bit_rate ? 0 : NUM2ULONG(video_bit_rate);

  TOXAV_ERR_ANSWER toxav_answer_error;

  const bool toxav_answer_result = toxav_answer(
    audio_video_cdata->tox_av,
    friend_number_data,
    audio_bit_rate_data,
    video_bit_rate_data,
    &toxav_answer_error
  );

  switch (toxav_answer_error) {
    case TOXAV_ERR_ANSWER_OK:
      break;
    case TOXAV_ERR_ANSWER_SYNC:
      RAISE_FUNC_ERROR(
        "toxav_answer",
        rb_eRuntimeError,
        "TOXAV_ERR_ANSWER_SYNC"
      );
    case TOXAV_ERR_ANSWER_CODEC_INITIALIZATION:
      RAISE_FUNC_ERROR(
        "toxav_answer",
        rb_eRuntimeError,
        "TOXAV_ERR_ANSWER_CODEC_INITIALIZATION"
      );
    case TOXAV_ERR_ANSWER_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "toxav_answer",
        rb_eRuntimeError,
        "TOXAV_ERR_ANSWER_FRIEND_NOT_FOUND"
      );
    case TOXAV_ERR_ANSWER_FRIEND_NOT_CALLING:
      RAISE_FUNC_ERROR(
        "toxav_answer",
        rb_eRuntimeError,
        "TOXAV_ERR_ANSWER_FRIEND_NOT_CALLING"
      );
    case TOXAV_ERR_ANSWER_INVALID_BIT_RATE:
      RAISE_FUNC_ERROR(
        "toxav_answer",
        rb_eRuntimeError,
        "TOXAV_ERR_ANSWER_INVALID_BIT_RATE"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("toxav_answer");
  }

  if (!toxav_answer_result) {
    RAISE_FUNC_RESULT("toxav_answer");
  }

  return Qnil;
}
