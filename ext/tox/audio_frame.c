#include "tox.h"

// Memory management
static VALUE mTox_cAudioFrame_alloc(VALUE klass);
static void  mTox_cAudioFrame_free(mTox_cAudioFrame_CDATA *free_cdata);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cAudioFrame_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cAudioFrame, mTox_cAudioFrame_alloc);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cAudioFrame_alloc(const VALUE klass)
{
  mTox_cAudioFrame_CDATA *alloc_cdata = ALLOC(mTox_cAudioFrame_CDATA);

  return Data_Wrap_Struct(klass, NULL, mTox_cAudioFrame_free, alloc_cdata);
}

void mTox_cAudioFrame_free(mTox_cAudioFrame_CDATA *const free_cdata)
{
  free(free_cdata);
}
