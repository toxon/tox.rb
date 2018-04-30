#include "tox.h"

// Memory management
static VALUE mTox_cAudioFrame_alloc(VALUE klass);
static void  mTox_cAudioFrame_free(mTox_cAudioFrame_CDATA *free_cdata);

// Public methods

static VALUE mTox_cAudioFrame_sample_count(VALUE self);
static VALUE mTox_cAudioFrame_sample_count_ASSIGN(VALUE self, VALUE sample_count);

static VALUE mTox_cAudioFrame_channels(VALUE self);
static VALUE mTox_cAudioFrame_channels_ASSIGN(VALUE self, VALUE channels);

static VALUE mTox_cAudioFrame_sampling_rate(VALUE self);
static VALUE mTox_cAudioFrame_sampling_rate_ASSIGN(VALUE self, VALUE sampling_rate);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cAudioFrame_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cAudioFrame, mTox_cAudioFrame_alloc);

  // Public methods

  rb_define_method(mTox_cAudioFrame, "sample_count",  mTox_cAudioFrame_sample_count,        0);
  rb_define_method(mTox_cAudioFrame, "sample_count=", mTox_cAudioFrame_sample_count_ASSIGN, 1);

  rb_define_method(mTox_cAudioFrame, "channels",  mTox_cAudioFrame_channels,        0);
  rb_define_method(mTox_cAudioFrame, "channels=", mTox_cAudioFrame_channels_ASSIGN, 1);

  rb_define_method(mTox_cAudioFrame, "sampling_rate",  mTox_cAudioFrame_sampling_rate,        0);
  rb_define_method(mTox_cAudioFrame, "sampling_rate=", mTox_cAudioFrame_sampling_rate_ASSIGN, 1);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cAudioFrame_alloc(const VALUE klass)
{
  mTox_cAudioFrame_CDATA *alloc_cdata = ALLOC(mTox_cAudioFrame_CDATA);

  memset(alloc_cdata, 0, sizeof(mTox_cAudioFrame_CDATA));

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

VALUE mTox_cAudioFrame_sample_count_ASSIGN(const VALUE self, const VALUE sample_count)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  self_cdata->sample_count = NUM2LONG(sample_count);

  return Qnil;
}

VALUE mTox_cAudioFrame_channels(const VALUE self)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  return UINT2NUM(self_cdata->channels);
}

VALUE mTox_cAudioFrame_channels_ASSIGN(const VALUE self, const VALUE channels)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  self_cdata->channels = NUM2UINT(channels);

  return Qnil;
}

VALUE mTox_cAudioFrame_sampling_rate(const VALUE self)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  return ULONG2NUM(self_cdata->sampling_rate);
}

VALUE mTox_cAudioFrame_sampling_rate_ASSIGN(const VALUE self, const VALUE sampling_rate)
{
  CDATA(self, mTox_cAudioFrame_CDATA, self_cdata);

  self_cdata->sampling_rate = NUM2ULONG(sampling_rate);

  return Qnil;
}
