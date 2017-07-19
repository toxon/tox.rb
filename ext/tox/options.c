#include "tox.h"
#include "options.h"

// Instance
VALUE mTox_cOptions;

// Memory management
static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(void *ptr);

// Public methods
static VALUE mTox_cOptions_initialize(VALUE self);
static VALUE mTox_cOptions_savedata(VALUE self);
static VALUE mTox_cOptions_savedata_EQUALS(VALUE self, VALUE savedata);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cOptions_INIT()
{
  mTox_cOptions = rb_define_class_under(mTox, "Options", rb_cObject);

  rb_define_alloc_func(mTox_cOptions, mTox_cOptions_alloc);

  rb_define_method(mTox_cOptions, "initialize", mTox_cOptions_initialize,      0);
  rb_define_method(mTox_cOptions, "savedata",   mTox_cOptions_savedata,        0);
  rb_define_method(mTox_cOptions, "savedata=",  mTox_cOptions_savedata_EQUALS, 1);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cOptions_alloc(const VALUE klass)
{
  mTox_cOptions_DATA *tox_options;

  tox_options = ALLOC(mTox_cOptions_DATA);

  return Data_Wrap_Struct(klass, NULL, mTox_cOptions_free, tox_options);
}

void mTox_cOptions_free(void *const ptr)
{
  free(ptr);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Options#initialize
VALUE mTox_cOptions_initialize(const VALUE self)
{
  mTox_cOptions_DATA *tox_options;

  Data_Get_Struct(self, mTox_cOptions_DATA, tox_options);

  tox_options_default(tox_options);

  return self;
}

// Tox::Options#savedata
VALUE mTox_cOptions_savedata(const VALUE self)
{
  mTox_cOptions_DATA *tox_options;

  Data_Get_Struct(self, mTox_cOptions_DATA, tox_options);

  switch (tox_options->savedata_type) {
    case TOX_SAVEDATA_TYPE_NONE:
      return Qnil;
    case TOX_SAVEDATA_TYPE_TOX_SAVE:
      return rb_str_new(tox_options->savedata_data, tox_options->savedata_length);
    default:
      rb_raise(rb_eNotImpError, "Tox::Options#savedata has unknown type");
  }
}

// Tox::Options#savedata=
VALUE mTox_cOptions_savedata_EQUALS(const VALUE self, const VALUE savedata)
{
  mTox_cOptions_DATA *tox_options;

  Data_Get_Struct(self, mTox_cOptions_DATA, tox_options);

  if (Qnil == savedata) {
    tox_options->savedata_type = TOX_SAVEDATA_TYPE_NONE;
    tox_options->savedata_data = NULL;
    tox_options->savedata_length = 0;

    return Qnil;
  }

  Check_Type(savedata, T_STRING);

  tox_options->savedata_type = TOX_SAVEDATA_TYPE_TOX_SAVE;
  tox_options->savedata_data = (uint8_t*)RSTRING_PTR(savedata);
  tox_options->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}
