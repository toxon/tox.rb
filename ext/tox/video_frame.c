#include "tox.h"

// Memory management
static VALUE mTox_cVideoFrame_alloc(VALUE klass);
static void  mTox_cVideoFrame_free(mTox_cVideoFrame_CDATA *free_cdata);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cVideoFrame_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cVideoFrame, mTox_cVideoFrame_alloc);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cVideoFrame_alloc(const VALUE klass)
{
  mTox_cVideoFrame_CDATA *alloc_cdata = ALLOC(mTox_cVideoFrame_CDATA);

  return Data_Wrap_Struct(klass, NULL, mTox_cVideoFrame_free, alloc_cdata);
}

void mTox_cVideoFrame_free(mTox_cVideoFrame_CDATA *const free_cdata)
{
  free(free_cdata);
}
