#include "tox.h"
#include "options.h"

VALUE cTox_cOptions;

static VALUE cTox_cOptions_alloc(VALUE klass);
static void  cTox_cOptions_free(void *ptr);
static VALUE cTox_cOptions_initialize(VALUE self);
static VALUE cTox_cOptions_savedata(VALUE self);
static VALUE cTox_cOptions_savedata_EQUALS(VALUE self, VALUE savedata);

void cTox_cOptions_INIT()
{
  cTox_cOptions = rb_define_class_under(cTox, "Options", rb_cObject);
  rb_define_alloc_func(cTox_cOptions, cTox_cOptions_alloc);
  rb_define_method(cTox_cOptions, "initialize", cTox_cOptions_initialize,      0);
  rb_define_method(cTox_cOptions, "savedata",   cTox_cOptions_savedata,        0);
  rb_define_method(cTox_cOptions, "savedata=",  cTox_cOptions_savedata_EQUALS, 1);
}

VALUE cTox_cOptions_alloc(const VALUE klass)
{
  cTox_cOptions_ *tox_options;

  tox_options = ALLOC(cTox_cOptions_);

  return Data_Wrap_Struct(klass, NULL, cTox_cOptions_free, tox_options);
}

void cTox_cOptions_free(void *const ptr)
{
  free(ptr);
}

VALUE cTox_cOptions_initialize(const VALUE self)
{
  cTox_cOptions_ *tox_options;

  Data_Get_Struct(self, cTox_cOptions_, tox_options);

  tox_options_default(tox_options);

  return self;
}

VALUE cTox_cOptions_savedata(const VALUE self)
{
  cTox_cOptions_ *tox_options;

  Data_Get_Struct(self, cTox_cOptions_, tox_options);

  return rb_str_new(tox_options->savedata_data, tox_options->savedata_length);
}

VALUE cTox_cOptions_savedata_EQUALS(const VALUE self, const VALUE savedata)
{
  cTox_cOptions_ *tox_options;

  Check_Type(savedata, T_STRING);

  Data_Get_Struct(self, cTox_cOptions_, tox_options);

  tox_options->savedata_type = TOX_SAVEDATA_TYPE_TOX_SAVE;
  tox_options->savedata_data = (uint8_t*)RSTRING_PTR(savedata);
  tox_options->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}
