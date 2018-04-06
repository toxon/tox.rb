#include "tox.h"

// Memory management
static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(void *free_cdata);

// Public methods

static VALUE mTox_cOptions_savedata(VALUE self);
static VALUE mTox_cOptions_savedata_ASSIGN(VALUE self, VALUE savedata);

static VALUE mTox_cOptions_ipv6_enabled(VALUE self);
static VALUE mTox_cOptions_ipv6_enabled_ASSIGN(VALUE self, VALUE enabled);

static VALUE mTox_cOptions_local_discovery_enabled(VALUE self);
static VALUE mTox_cOptions_local_discovery_enabled_ASSIGN(VALUE self, VALUE enabled);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cOptions_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cOptions, mTox_cOptions_alloc);

  // Public methods
  rb_define_method(mTox_cOptions, "savedata",  mTox_cOptions_savedata,        0);
  rb_define_method(mTox_cOptions, "savedata=", mTox_cOptions_savedata_ASSIGN, 1);

  rb_define_method(mTox_cOptions, "ipv6_enabled",  mTox_cOptions_ipv6_enabled,        0);
  rb_define_method(mTox_cOptions, "ipv6_enabled=", mTox_cOptions_ipv6_enabled_ASSIGN, 1);

  rb_define_method(mTox_cOptions, "local_discovery_enabled",  mTox_cOptions_local_discovery_enabled,        0);
  rb_define_method(mTox_cOptions, "local_discovery_enabled=", mTox_cOptions_local_discovery_enabled_ASSIGN, 1);
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
    {
      const VALUE savedata =
        rb_str_new(self_cdata->savedata_data, self_cdata->savedata_length);
      return savedata;
    }
    default:
      RAISE_ENUM("TOX_SAVEDATA_TYPE");
  }
}

// Tox::Options#savedata=
VALUE mTox_cOptions_savedata_ASSIGN(const VALUE self, const VALUE savedata)
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
  self_cdata->savedata_data = RSTRING_PTR(savedata);
  self_cdata->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}

// Tox::Options#ipv6_enabled
VALUE mTox_cOptions_ipv6_enabled(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_ipv6_enabled(self_cdata)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#ipv6_enabled=
VALUE mTox_cOptions_ipv6_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_ipv6_enabled(self_cdata, RTEST(enabled));

  return enabled;
}

// Tox::Options#local_discovery_enabled
VALUE mTox_cOptions_local_discovery_enabled(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_local_discovery_enabled(self_cdata)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#local_discovery_enabled=
VALUE mTox_cOptions_local_discovery_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_local_discovery_enabled(self_cdata, RTEST(enabled));

  return enabled;
}
