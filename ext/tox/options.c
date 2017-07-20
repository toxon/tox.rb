#include "tox.h"
#include "options.h"

// Instance
VALUE mTox_cOptions;

// Memory management
static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(void *free_cdata);

// Public methods
static VALUE mTox_cOptions_savedata(VALUE self);
static VALUE mTox_cOptions_savedata_EQUALS(VALUE self, VALUE savedata);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cOptions_INIT()
{
  mTox_cOptions = rb_define_class_under(mTox, "Options", rb_cObject);

  rb_define_alloc_func(mTox_cOptions, mTox_cOptions_alloc);

  rb_define_method(mTox_cOptions, "savedata",  mTox_cOptions_savedata,        0);
  rb_define_method(mTox_cOptions, "savedata=", mTox_cOptions_savedata_EQUALS, 1);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cOptions_alloc(const VALUE klass)
{
  mTox_cOptions_CDATA *alloc_cdata = ALLOC(mTox_cOptions_CDATA);

  tox_options_default(alloc_cdata);

  return Data_Wrap_Struct(klass, NULL, mTox_cOptions_free, alloc_cdata);
}

void mTox_cOptions_free(void *const free_cdata)
{
  free(free_cdata);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Options#savedata
VALUE mTox_cOptions_savedata(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  switch (self_cdata->savedata_type) {
    case TOX_SAVEDATA_TYPE_NONE:
      return Qnil;
    case TOX_SAVEDATA_TYPE_TOX_SAVE:
      return rb_str_new(self_cdata->savedata_data, self_cdata->savedata_length);
    default:
      rb_raise(rb_eNotImpError, "Tox::Options#savedata has unknown type");
  }
}

// Tox::Options#savedata=
VALUE mTox_cOptions_savedata_EQUALS(const VALUE self, const VALUE savedata)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  if (Qnil == savedata) {
    self_cdata->savedata_type = TOX_SAVEDATA_TYPE_NONE;
    self_cdata->savedata_data = NULL;
    self_cdata->savedata_length = 0;

    return Qnil;
  }

  Check_Type(savedata, T_STRING);

  self_cdata->savedata_type = TOX_SAVEDATA_TYPE_TOX_SAVE;
  self_cdata->savedata_data = (uint8_t*)RSTRING_PTR(savedata);
  self_cdata->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}
