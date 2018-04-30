#include "tox.h"

// Memory management
static VALUE mTox_cAudioFrame_alloc(VALUE klass);
static void  mTox_cAudioFrame_free(mTox_cAudioFrame_CDATA *free_cdata);

// Public methods

static VALUE mTox_cAudioFrame_sample_count(VALUE self);
static VALUE mTox_cAudioFrame_channels(VALUE self);
static VALUE mTox_cAudioFrame_sampling_rate(VALUE self);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cAudioFrame_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cAudioFrame, mTox_cAudioFrame_alloc);

  // Public methods

  rb_define_method(mTox_cAudioFrame, "sample_count",
                   mTox_cAudioFrame_sample_count, 0);
  rb_define_method(mTox_cAudioFrame, "channels",
                   mTox_cAudioFrame_channels, 0);
  rb_define_method(mTox_cAudioFrame, "sampling_rate",
                   mTox_cAudioFrame_sampling_rate, 0);
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

/*************************************************************
 * Public methods
 *************************************************************/

VALUE mTox_cAudioFrame_sample_count(const VALUE self)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  return LONG2NUM(self_cdata->sample_count);
}

VALUE mTox_cAudioFrame_channels(const VALUE self)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  return UINT2NUM(self_cdata->channels);
}

VALUE mTox_cAudioFrame_sampling_rate(const VALUE self)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  return ULONG2NUM(self_cdata->sampling_rate);
}
