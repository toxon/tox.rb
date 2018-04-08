#include "tox.h"

// Memory management
static VALUE mTox_cOptions_alloc(VALUE klass);
static void  mTox_cOptions_free(mTox_cOptions_CDATA *free_cdata);

// Public methods

static VALUE mTox_cOptions_initialize(VALUE self);

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

static VALUE mTox_cOptions_proxy_host(VALUE self);
static VALUE mTox_cOptions_proxy_host_ASSIGN(VALUE self, VALUE proxy_host);

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
  rb_define_method(mTox_cOptions, "initialize", mTox_cOptions_initialize, 0);

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

  rb_define_method(mTox_cOptions, "proxy_host",  mTox_cOptions_proxy_host,        0);
  rb_define_method(mTox_cOptions, "proxy_host=", mTox_cOptions_proxy_host_ASSIGN, 1);

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

  alloc_cdata->tox_options = NULL;

  return Data_Wrap_Struct(klass, NULL, mTox_cOptions_free, alloc_cdata);
}

void mTox_cOptions_free(mTox_cOptions_CDATA *const free_cdata)
{
  if (free_cdata->tox_options) {
    tox_options_free(free_cdata->tox_options);
  }

  free(free_cdata);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Options#initialize
VALUE mTox_cOptions_initialize(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  TOX_ERR_OPTIONS_NEW error;

  self_cdata->tox_options = tox_options_new(&error);

  tox_options_set_proxy_host(self_cdata->tox_options, NULL);

  switch (error) {
    case TOX_ERR_OPTIONS_NEW_OK:
      break;
    case TOX_ERR_OPTIONS_NEW_MALLOC:
      RAISE_FUNC_ERROR(
        "tox_options_new",
        rb_eNoMemError,
        "TOX_ERR_OPTIONS_NEW_MALLOC"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_options_new");
  }

  if (!self_cdata->tox_options) {
    RAISE_FUNC_RESULT("tox_options_new");
  }

  return self;
}

// Tox::Options#savedata
VALUE mTox_cOptions_savedata(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  switch (self_cdata->tox_options->savedata_type) {
    case TOX_SAVEDATA_TYPE_NONE:
      return Qnil;
    case TOX_SAVEDATA_TYPE_TOX_SAVE:
    {
      const VALUE savedata = rb_str_new(
        self_cdata->tox_options->savedata_data,
        self_cdata->tox_options->savedata_length
      );
      return savedata;
    }
    default:
      RAISE_ENUM("TOX_SAVEDATA_TYPE");
  }
}

// Tox::Options#savedata=
VALUE mTox_cOptions_savedata_ASSIGN(const VALUE self, const VALUE savedata)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  if (Qnil == savedata) {
    self_cdata->tox_options->savedata_type = TOX_SAVEDATA_TYPE_NONE;
    self_cdata->tox_options->savedata_data = NULL;
    self_cdata->tox_options->savedata_length = 0;

    return Qnil;
  }

  Check_Type(savedata, T_STRING);

  self_cdata->tox_options->savedata_type = TOX_SAVEDATA_TYPE_TOX_SAVE;
  self_cdata->tox_options->savedata_data = RSTRING_PTR(savedata);
  self_cdata->tox_options->savedata_length = RSTRING_LEN(savedata);

  return savedata;
}

// Tox::Options#ipv6_enabled
VALUE mTox_cOptions_ipv6_enabled(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_ipv6_enabled(self_cdata->tox_options)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#ipv6_enabled=
VALUE mTox_cOptions_ipv6_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_ipv6_enabled(self_cdata->tox_options, RTEST(enabled));

  return enabled;
}

// Tox::Options#udp_enabled
VALUE mTox_cOptions_udp_enabled(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_udp_enabled(self_cdata->tox_options)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#udp_enabled=
VALUE mTox_cOptions_udp_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_udp_enabled(self_cdata->tox_options, RTEST(enabled));

  return enabled;
}

// Tox::Options#local_discovery_enabled
VALUE mTox_cOptions_local_discovery_enabled(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  if (tox_options_get_local_discovery_enabled(self_cdata->tox_options)) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Options#local_discovery_enabled=
VALUE mTox_cOptions_local_discovery_enabled_ASSIGN(const VALUE self, const VALUE enabled)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_local_discovery_enabled(self_cdata->tox_options, RTEST(enabled));

  return enabled;
}

// Tox::Options#proxy_type
VALUE mTox_cOptions_proxy_type(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const TOX_PROXY_TYPE proxy_type_data = tox_options_get_proxy_type(self_cdata->tox_options);

  const VALUE proxy_type = mTox_mProxyType_FROM_DATA(proxy_type_data);

  return proxy_type;
}

// Tox::Options#proxy_type=
VALUE mTox_cOptions_proxy_type_ASSIGN(const VALUE self, const VALUE proxy_type)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const TOX_PROXY_TYPE proxy_type_data = mTox_mProxyType_TO_DATA(proxy_type);

  tox_options_set_proxy_type(self_cdata->tox_options, proxy_type_data);

  return proxy_type;
}

// Tox::Options#proxy_host
VALUE mTox_cOptions_proxy_host(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const char *proxy_host_data = tox_options_get_proxy_host(self_cdata->tox_options);

  if (!proxy_host_data) {
    return Qnil;
  }

  const VALUE proxy_host = rb_str_new_cstr(self_cdata->tox_options->proxy_host);

  return proxy_host;
}

// Tox::Options#proxy_host=
VALUE mTox_cOptions_proxy_host_ASSIGN(const VALUE self, const VALUE proxy_host)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  tox_options_set_proxy_host(self_cdata->tox_options, NULL);

  if (proxy_host == Qnil) {
    return Qnil;
  }

  Check_Type(proxy_host, T_STRING);

  const char *proxy_host_data         = RSTRING_PTR(proxy_host);
  const size_t proxy_host_length_data = RSTRING_LEN(proxy_host);

  if (proxy_host_length_data == 0 || proxy_host_data[0] == '\0') {
    return Qnil;
  }

  if (proxy_host_length_data > 255) {
    rb_raise(
      rb_eRuntimeError,
      "Proxy host string can not be longer than 255 bytes"
    );
  }

  memcpy(self_cdata->proxy_host, proxy_host_data, proxy_host_length_data);
  self_cdata->proxy_host[proxy_host_length_data] = '\0';

  tox_options_set_proxy_host(self_cdata->tox_options, self_cdata->proxy_host);

  return proxy_host;
}

// Tox::Options#proxy_port
VALUE mTox_cOptions_proxy_port(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t proxy_port_data = tox_options_get_proxy_port(self_cdata->tox_options);

  const VALUE proxy_port = LONG2FIX(proxy_port_data);

  return proxy_port;
}

// Tox::Options#start_port
VALUE mTox_cOptions_start_port(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t start_port_data = tox_options_get_start_port(self_cdata->tox_options);

  const VALUE start_port = LONG2FIX(start_port_data);

  return start_port;
}

// Tox::Options#end_port
VALUE mTox_cOptions_end_port(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t end_port_data = tox_options_get_end_port(self_cdata->tox_options);

  const VALUE end_port = LONG2FIX(end_port_data);

  return end_port;
}

// Tox::Options#tcp_port
VALUE mTox_cOptions_tcp_port(const VALUE self)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t tcp_port_data = tox_options_get_tcp_port(self_cdata->tox_options);

  const VALUE tcp_port = LONG2FIX(tcp_port_data);

  return tcp_port;
}

/*************************************************************
 * Private methods
 *************************************************************/

// Tox::Options#proxy_port_internal=
VALUE mTox_cOptions_proxy_port_internal_ASSIGN(const VALUE self, const VALUE proxy_port)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t proxy_port_data = FIX2LONG(proxy_port);

  tox_options_set_proxy_port(self_cdata->tox_options, proxy_port_data);

  return proxy_port;
}

// Tox::Options#start_port_internal=
VALUE mTox_cOptions_start_port_internal_ASSIGN(const VALUE self, const VALUE start_port)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t start_port_data = FIX2LONG(start_port);

  tox_options_set_start_port(self_cdata->tox_options, start_port_data);

  return start_port;
}

// Tox::Options#end_port_internal=
VALUE mTox_cOptions_end_port_internal_ASSIGN(const VALUE self, const VALUE end_port)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t end_port_data = FIX2LONG(end_port);

  tox_options_set_end_port(self_cdata->tox_options, end_port_data);

  return end_port;
}

// Tox::Options#tcp_port_internal=
VALUE mTox_cOptions_tcp_port_internal_ASSIGN(const VALUE self, const VALUE tcp_port)
{
  CDATA(self, mTox_cOptions_CDATA, self_cdata);

  const uint16_t tcp_port_data = FIX2LONG(tcp_port);

  tox_options_set_tcp_port(self_cdata->tox_options, tcp_port_data);

  return tcp_port;
}
