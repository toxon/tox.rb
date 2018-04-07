#include "tox.h"

// Memory management
static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(void *free_cdata);

// Public methods

static VALUE mTox_cOptions_savedata(VALUE self);
static VALUE mTox_cOptions_savedata_ASSIGN(VALUE self, VALUE savedata);

static VALUE mTox_cOptions_ipv6_enabled(VALUE self);
static VALUE mTox_cOptions_ipv6_enabled_ASSIGN(VALUE self, VALUE enabled);

static VALUE mTox_cOptions_udp_enabled(VALUE self);
static VALUE mTox_cOptions_udp_enabled_ASSIGN(VALUE self, VALUE enabled);

static VALUE mTox_cOptions_local_discovery_enabled(VALUE self);
static VALUE mTox_cOptions_local_discovery_enabled_ASSIGN(VALUE self, VALUE enabled);

static VALUE mTox_cOptions_proxy_type(VALUE self);
static VALUE mTox_cOptions_proxy_type_ASSIGN(VALUE self, VALUE proxy_type);

static VALUE mTox_cOptions_proxy_port(VALUE self);
static VALUE mTox_cOptions_start_port(VALUE self);
static VALUE mTox_cOptions_end_port(VALUE self);
static VALUE mTox_cOptions_tcp_port(VALUE self);

// Private methods

static VALUE mTox_cOptions_proxy_port_internal_ASSIGN(VALUE self, VALUE proxy_port);
static VALUE mTox_cOptions_start_port_internal_ASSIGN(VALUE self, VALUE start_port);
static VALUE mTox_cOptions_end_port_internal_ASSIGN(VALUE self, VALUE end_port);
static VALUE mTox_cOptions_tcp_port_internal_ASSIGN(VALUE self, VALUE tcp_port);

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

  rb_define_method(mTox_cOptions, "udp_enabled",  mTox_cOptions_udp_enabled,        0);
  rb_define_method(mTox_cOptions, "udp_enabled=", mTox_cOptions_udp_enabled_ASSIGN, 1);

  rb_define_method(mTox_cOptions, "local_discovery_enabled",  mTox_cOptions_local_discovery_enabled,        0);
  rb_define_method(mTox_cOptions, "local_discovery_enabled=", mTox_cOptions_local_discovery_enabled_ASSIGN, 1);

  rb_define_method(mTox_cOptions, "proxy_type",  mTox_cOptions_proxy_type,        0);
  rb_define_method(mTox_cOptions, "proxy_type=", mTox_cOptions_proxy_type_ASSIGN, 1);

  rb_define_method(mTox_cOptions, "proxy_port", mTox_cOptions_proxy_port, 0);
  rb_define_method(mTox_cOptions, "start_port", mTox_cOptions_start_port, 0);
  rb_define_method(mTox_cOptions, "end_port",   mTox_cOptions_end_port,   0);
  rb_define_method(mTox_cOptions, "tcp_port",   mTox_cOptions_tcp_port,   0);

  // Private methods
  rb_define_private_method(mTox_cOptions, "proxy_port_internal=", mTox_cOptions_proxy_port_internal_ASSIGN, 1);
  rb_define_private_method(mTox_cOptions, "start_port_internal=", mTox_cOptions_start_port_internal_ASSIGN, 1);
  rb_define_private_method(mTox_cOptions, "end_port_internal=",   mTox_cOptions_end_port_internal_ASSIGN,   1);
  rb_define_private_method(mTox_cOptions, "tcp_port_internal=",   mTox_cOptions_tcp_port_internal_ASSIGN,   1);
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

// Tox::Options#udp_enabled
VALUE mTox_cOptions_udp_enabled(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_udp_enabled(self_cdata)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#udp_enabled=
VALUE mTox_cOptions_udp_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_udp_enabled(self_cdata, RTEST(enabled));

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

// Tox::Options#proxy_type
VALUE mTox_cOptions_proxy_type(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const TOX_PROXY_TYPE proxy_type_data = tox_options_get_proxy_type(self_cdata);

  const VALUE proxy_type = mTox_mProxyType_FROM_DATA(proxy_type_data);

  return proxy_type;
}

// Tox::Options#proxy_type=
VALUE mTox_cOptions_proxy_type_ASSIGN(const VALUE self, const VALUE proxy_type)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const TOX_PROXY_TYPE proxy_type_data = mTox_mProxyType_TO_DATA(proxy_type);

  tox_options_set_proxy_type(self_cdata, proxy_type_data);

  return proxy_type;
}

// Tox::Options#proxy_port
VALUE mTox_cOptions_proxy_port(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t proxy_port_data = tox_options_get_proxy_port(self_cdata);

  const VALUE proxy_port = LONG2FIX(proxy_port_data);

  return proxy_port;
}

// Tox::Options#start_port
VALUE mTox_cOptions_start_port(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t start_port_data = tox_options_get_start_port(self_cdata);

  const VALUE start_port = LONG2FIX(start_port_data);

  return start_port;
}

// Tox::Options#end_port
VALUE mTox_cOptions_end_port(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t end_port_data = tox_options_get_end_port(self_cdata);

  const VALUE end_port = LONG2FIX(end_port_data);

  return end_port;
}

// Tox::Options#tcp_port
VALUE mTox_cOptions_tcp_port(const VALUE self)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t tcp_port_data = tox_options_get_tcp_port(self_cdata);

  const VALUE tcp_port = LONG2FIX(tcp_port_data);

  return tcp_port;
}

/*************************************************************
 * Private methods
 *************************************************************/

// Tox::Options#proxy_port_internal=
VALUE mTox_cOptions_proxy_port_internal_ASSIGN(const VALUE self, const VALUE proxy_port)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t proxy_port_data = FIX2LONG(proxy_port);

  tox_options_set_proxy_port(self_cdata, proxy_port_data);

  return proxy_port;
}

// Tox::Options#start_port_internal=
VALUE mTox_cOptions_start_port_internal_ASSIGN(const VALUE self, const VALUE start_port)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t start_port_data = FIX2LONG(start_port);

  tox_options_set_start_port(self_cdata, start_port_data);

  return start_port;
}

// Tox::Options#end_port_internal=
VALUE mTox_cOptions_end_port_internal_ASSIGN(const VALUE self, const VALUE end_port)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t end_port_data = FIX2LONG(end_port);

  tox_options_set_end_port(self_cdata, end_port_data);

  return end_port;
}

// Tox::Options#tcp_port_internal=
VALUE mTox_cOptions_tcp_port_internal_ASSIGN(const VALUE self, const VALUE tcp_port)
{
  mTox_cOptions_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t tcp_port_data = FIX2LONG(tcp_port);

  tox_options_set_tcp_port(self_cdata, tcp_port_data);

  return tcp_port;
}
