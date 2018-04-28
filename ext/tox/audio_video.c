#include "tox.h"

// Memory management

static VALUE mTox_cAudioVideo_alloc(VALUE klass);
static void  mTox_cAudioVideo_free(mTox_cAudioVideo_CDATA *free_cdata);

// Private methods

static VALUE mTox_cAudioVideo_initialize_with(VALUE self, VALUE client);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cAudioVideo_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cAudioVideo, mTox_cAudioVideo_alloc);

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

  return self;
}
