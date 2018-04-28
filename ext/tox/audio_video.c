#include "tox.h"

// Memory management

static VALUE mTox_cAudioVideo_alloc(VALUE klass);
static void  mTox_cAudioVideo_free(mTox_cAudioVideo_CDATA *free_cdata);

// Public methods

static VALUE mTox_cAudioVideo_pointer(VALUE self);

static VALUE mTox_cAudioVideo_iteration_interval(VALUE self);
static VALUE mTox_cAudioVideo_iterate(VALUE self);

// Private methods

static VALUE mTox_cAudioVideo_initialize_with(VALUE self, VALUE client);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cAudioVideo_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cAudioVideo, mTox_cAudioVideo_alloc);

  // Public methods

  rb_define_method(mTox_cAudioVideo, "pointer", mTox_cAudioVideo_pointer, 0);

  rb_define_method(mTox_cAudioVideo, "iteration_interval", mTox_cAudioVideo_iteration_interval, 0);
  rb_define_method(mTox_cAudioVideo, "iterate",            mTox_cAudioVideo_iterate,            0);

  // Private methods

  rb_define_private_method(mTox_cAudioVideo, "initialize_with", mTox_cAudioVideo_initialize_with, 1);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cAudioVideo_alloc(const VALUE klass)
{
  mTox_cAudioVideo_CDATA *alloc_cdata = ALLOC(mTox_cAudioVideo_CDATA);

  alloc_cdata->tox_av = NULL;

  return Data_Wrap_Struct(klass, NULL, mTox_cAudioVideo_free, alloc_cdata);
}

void mTox_cAudioVideo_free(mTox_cAudioVideo_CDATA *const free_cdata)
{
  if (free_cdata->tox_av) {
    toxav_kill(free_cdata->tox_av);
  }

  free(free_cdata);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::AudioVideo#pointer
VALUE mTox_cAudioVideo_pointer(const VALUE self)
{
  CDATA(self, mTox_cAudioVideo_CDATA, self_cdata);

  return ULL2NUM(self_cdata->tox_av);
}

// Tox::AudioVideo#iteration_interval
VALUE mTox_cAudioVideo_iteration_interval(const VALUE self)
{
  CDATA(self, mTox_cAudioVideo_CDATA, self_cdata);

  uint32_t iteration_interval_msec_data =
    toxav_iteration_interval(self_cdata->tox_av);

  const double iteration_interval_sec_data =
    ((double)iteration_interval_msec_data) * 0.001;

  const VALUE iteration_interval_sec = DBL2NUM(iteration_interval_sec_data);

  return iteration_interval_sec;
}

// Tox::AudioVideo#iterate
VALUE mTox_cAudioVideo_iterate(const VALUE self)
{
  CDATA(self, mTox_cAudioVideo_CDATA, self_cdata);

  toxav_iterate(self_cdata->tox_av);

  return Qnil;
}

/*************************************************************
 * Private methods
 *************************************************************/

// Tox::AudioVideo#initialize_with
VALUE mTox_cAudioVideo_initialize_with(const VALUE self, const VALUE client)
{
  if (!rb_funcall(client, rb_intern("is_a?"), 1, mTox_cClient)) {
    RAISE_TYPECHECK("Tox::AudioVideo#initialize_with", "client", "Tox::Client");
  }

  CDATA(self,   mTox_cAudioVideo_CDATA, self_cdata);
  CDATA(client, mTox_cClient_CDATA,     client_cdata);

  TOXAV_ERR_NEW error;

  self_cdata->tox_av = toxav_new(client_cdata->tox, &error);

  switch (error) {
    case TOXAV_ERR_NEW_OK:
      break;
    case TOXAV_ERR_NEW_NULL:
      RAISE_FUNC_ERROR(
        "toxav_new",
        mTox_eNullError,
        "TOXAV_ERR_NEW_NULL"
      );
    case TOXAV_ERR_NEW_MALLOC:
      RAISE_FUNC_ERROR(
        "toxav_new",
        rb_eNoMemError,
        "TOXAV_ERR_NEW_MALLOC"
      );
    case TOXAV_ERR_NEW_MULTIPLE:
      RAISE_FUNC_ERROR(
        "toxav_new",
        rb_eRuntimeError,
        "TOXAV_ERR_NEW_MULTIPLE"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("toxav_new");
  }

  if (!self_cdata->tox_av) {
    RAISE_FUNC_RESULT("toxav_new");
  }

  // Callbacks
  toxav_callback_call               (self_cdata->tox_av, on_call,              self);
  toxav_callback_audio_receive_frame(self_cdata->tox_av, on_audio_frame,       self);

  return self;
}
