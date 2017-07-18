#include "tox.h"
#include "options.h"

VALUE mTox_cOptions;

static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(void *ptr);
static VALUE mTox_cOptions_initialize(VALUE self);
static VALUE mTox_cOptions_savedata(VALUE self);
static VALUE mTox_cOptions_savedata_EQUALS(VALUE self, VALUE savedata);

void mTox_cOptions_INIT()
{
  mTox_cOptions = rb_define_class_under(mTox, "Options", rb_cObject);
  rb_define_alloc_func(mTox_cOptions, mTox_cOptions_alloc);
  rb_define_method(mTox_cOptions, "initialize", mTox_cOptions_initialize,      0);
  rb_define_method(mTox_cOptions, "savedata",   mTox_cOptions_savedata,        0);
  rb_define_method(mTox_cOptions, "savedata=",  mTox_cOptions_savedata_EQUALS, 1);
}

VALUE mTox_cOptions_alloc(const VALUE klass)
{
  mTox_cOptions_ *tox_options;

  tox_options = ALLOC(mTox_cOptions_);

  return Data_Wrap_Struct(klass, NULL, mTox_cOptions_free, tox_options);
}

void mTox_cOptions_free(void *const ptr)
{
  free(ptr);
}

VALUE mTox_cOptions_initialize(const VALUE self)
{
  mTox_cOptions_ *tox_options;

  Data_Get_Struct(self, mTox_cOptions_, tox_options);

  tox_options_default(tox_options);

  return self;
}

VALUE mTox_cOptions_savedata(const VALUE self)
{
  mTox_cOptions_ *tox_options;

  Data_Get_Struct(self, mTox_cOptions_, tox_options);

  return rb_str_new(tox_options->savedata_data, tox_options->savedata_length);
}

VALUE mTox_cOptions_savedata_EQUALS(const VALUE self, const VALUE savedata)
{
  mTox_cOptions_ *tox_options;

  Check_Type(savedata, T_STRING);

  Data_Get_Struct(self, mTox_cOptions_, tox_options);

  tox_options->savedata_type = TOX_SAVEDATA_TYPE_TOX_SAVE;
  tox_options->savedata_data = (uint8_t*)RSTRING_PTR(savedata);
  tox_options->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}
