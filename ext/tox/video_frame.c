#include "tox.h"

// Memory management
static VALUE mTox_cVideoFrame_alloc(VALUE klass);
static void  mTox_cVideoFrame_free(mTox_cVideoFrame_CDATA *free_cdata);

// Public methods

static VALUE mTox_cVideoFrame_width(VALUE self);
static VALUE mTox_cVideoFrame_width_ASSIGN(VALUE self, VALUE width);

static VALUE mTox_cVideoFrame_height(VALUE self);
static VALUE mTox_cVideoFrame_height_ASSIGN(VALUE self, VALUE height);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cVideoFrame_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cVideoFrame, mTox_cVideoFrame_alloc);

  // Public methods

  rb_define_method(mTox_cVideoFrame, "width",  mTox_cVideoFrame_width,        0);
  rb_define_method(mTox_cVideoFrame, "width=", mTox_cVideoFrame_width_ASSIGN, 1);

  rb_define_method(mTox_cVideoFrame, "height",  mTox_cVideoFrame_height,        0);
  rb_define_method(mTox_cVideoFrame, "height=", mTox_cVideoFrame_height_ASSIGN, 1);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cVideoFrame_alloc(const VALUE klass)
{
  mTox_cVideoFrame_CDATA *alloc_cdata = ALLOC(mTox_cVideoFrame_CDATA);

  memset(alloc_cdata, 0, sizeof(mTox_cVideoFrame_CDATA));

  return Data_Wrap_Struct(klass, NULL, mTox_cVideoFrame_free, alloc_cdata);
}

void mTox_cVideoFrame_free(mTox_cVideoFrame_CDATA *const free_cdata)
{
  if (free_cdata->y) {
    free(free_cdata->y);
  }

  if (free_cdata->u) {
    free(free_cdata->u);
  }

  if (free_cdata->v) {
    free(free_cdata->v);
  }

  free(free_cdata);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::VideoFrame#width
VALUE mTox_cVideoFrame_width(const VALUE self)
{
  CDATA(self, mTox_cVideoFrame_CDATA, self_cdata);

  return UINT2NUM(self_cdata->width);
}

// Tox::VideoFrame#width=
VALUE mTox_cVideoFrame_width_ASSIGN(const VALUE self, const VALUE width)
{
  CDATA(self, mTox_cVideoFrame_CDATA, self_cdata);

  self_cdata->width = NUM2UINT(width);

  return Qnil;
}

// Tox::VideoFrame#height
VALUE mTox_cVideoFrame_height(const VALUE self)
{
  CDATA(self, mTox_cVideoFrame_CDATA, self_cdata);

  return UINT2NUM(self_cdata->height);
}

// Tox::VideoFrame#height=
VALUE mTox_cVideoFrame_height_ASSIGN(const VALUE self, const VALUE height)
{
  CDATA(self, mTox_cVideoFrame_CDATA, self_cdata);

  self_cdata->height = NUM2UINT(height);

  return Qnil;
}
