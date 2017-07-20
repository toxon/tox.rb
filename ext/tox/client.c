#include "tox.h"
#include "client.h"
#include "options.h"
#include "node.h"
#include "friend.h"

#include <time.h>

// Instance
VALUE mTox_cClient;

// Memory management
static VALUE mTox_cClient_alloc(VALUE klass);
static void  mTox_cClient_free(mTox_cClient_CDATA *free_cdata);

// Public methods
static VALUE mTox_cClient_savedata(VALUE self);
static VALUE mTox_cClient_id(VALUE self);
static VALUE mTox_cClient_bootstrap(VALUE self, VALUE node);
static VALUE mTox_cClient_name(VALUE self);
static VALUE mTox_cClient_name_EQUALS(VALUE self, VALUE name);
static VALUE mTox_cClient_friend_add_norequest(VALUE self, VALUE public_key);

// Private methods
static VALUE mTox_cClient_initialize_with(VALUE self, VALUE options);
static VALUE mTox_cClient_run_loop(VALUE self);

// Callbacks

static void on_friend_request(
  Tox *tox,
  const uint8_t *public_key,
  const uint8_t *data,
  size_t length,
  VALUE self
);

static void on_friend_message(
  Tox *tox,
  uint32_t friend_number,
  TOX_MESSAGE_TYPE type,
  const uint8_t *text,
  size_t length,
  VALUE self
);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cClient_INIT()
{
  mTox_cClient = rb_define_class_under(mTox, "Client", rb_cObject);

  // Memory management
  rb_define_alloc_func(mTox_cClient, mTox_cClient_alloc);

  // Public methods
  rb_define_method(mTox_cClient, "savedata",             mTox_cClient_savedata,             0);
  rb_define_method(mTox_cClient, "id",                   mTox_cClient_id,                   0);
  rb_define_method(mTox_cClient, "bootstrap",            mTox_cClient_bootstrap,            1);
  rb_define_method(mTox_cClient, "name",                 mTox_cClient_name,                 0);
  rb_define_method(mTox_cClient, "name=",                mTox_cClient_name_EQUALS,          1);
  rb_define_method(mTox_cClient, "friend_add_norequest", mTox_cClient_friend_add_norequest, 1);

  // Private methods
  rb_define_private_method(mTox_cClient, "initialize_with", mTox_cClient_initialize_with, 1);
  rb_define_private_method(mTox_cClient, "run_loop",        mTox_cClient_run_loop,        0);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cClient_alloc(const VALUE klass)
{
  mTox_cClient_CDATA *alloc_cdata = ALLOC(mTox_cClient_CDATA);

  alloc_cdata->tox = NULL;

  return Data_Wrap_Struct(klass, NULL, mTox_cClient_free, alloc_cdata);
}

void mTox_cClient_free(mTox_cClient_CDATA *const free_cdata)
{
  if (free_cdata->tox) {
    tox_kill(free_cdata->tox);
  }

  free(free_cdata);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Client#savedata
VALUE mTox_cClient_savedata(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  size_t data_size;
  char *data;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  data_size = tox_get_savedata_size(self_cdata->tox);
  data = ALLOC_N(char, data_size);

  tox_get_savedata(self_cdata->tox, (uint8_t*)data);

  return rb_str_new(data, data_size);
}

// Tox::Client#id
VALUE mTox_cClient_id(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  char address[TOX_ADDRESS_SIZE];

  tox_self_get_address(self_cdata->tox, (uint8_t*)address);

  char id[2 * TOX_ADDRESS_SIZE];

  for (unsigned long i = 0; i < TOX_ADDRESS_SIZE; ++i) {
    sprintf(&id[2 * i], "%02X", address[i] & 0xFF);
  }

  return rb_str_new(id, 2 * TOX_ADDRESS_SIZE);
}

// Tox::Client#bootstrap
VALUE mTox_cClient_bootstrap(const VALUE self, const VALUE node)
{
  if (!rb_funcall(node, rb_intern("is_a?"), 1, mTox_cNode)) {
    rb_raise(rb_eTypeError, "expected argument 1 to be a Tox::Node");
  }

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const char *const public_key = RSTRING_PTR(rb_funcall(node, rb_intern("public_key"), 0));

  uint8_t public_key_bin[TOX_PUBLIC_KEY_SIZE];

  for (long i = 0; i < TOX_PUBLIC_KEY_SIZE; ++i) {
    sscanf(&public_key[i * 2], "%2hhx", &public_key_bin[i]);
  }

  TOX_ERR_BOOTSTRAP error;

  tox_bootstrap(self_cdata->tox,
                RSTRING_PTR(rb_funcall(node, rb_intern("ipv4"), 0)),
                NUM2INT(rb_funcall(node, rb_intern("port"), 0)),
                public_key_bin,
                &error);

  switch (error) {
    case TOX_ERR_BOOTSTRAP_OK:
      return Qtrue;
    default:
      return Qfalse;
  }
}

// Tox::Client#name
VALUE mTox_cClient_name(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const size_t name_size = tox_self_get_name_size(self_cdata->tox);

  char name[name_size];

  if (name_size > 0) {
    tox_self_get_name(self_cdata->tox, (uint8_t*)name);
  }

  return rb_str_new(name, name_size);
}

// Tox::Client#name=
VALUE mTox_cClient_name_EQUALS(const VALUE self, const VALUE name)
{
  Check_Type(name, T_STRING);

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_SET_INFO error;

  const bool result = tox_self_set_name(
    self_cdata->tox,
    (uint8_t**)RSTRING_PTR(name),
    RSTRING_LEN(name),
    &error
  );

  switch (error) {
    case TOX_ERR_SET_INFO_OK:
      break;
    default:
      rb_raise(rb_eRuntimeError, "tox_self_set_name() failed");
  }

  return name;
}

// Tox::Client#friend_add_norequest
VALUE mTox_cClient_friend_add_norequest(const VALUE self, const VALUE public_key)
{
  Check_Type(public_key, T_STRING);

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  return LONG2FIX(tox_friend_add_norequest(self_cdata->tox, (uint8_t*)RSTRING_PTR(public_key), NULL));
}

/*************************************************************
 * Private methods
 *************************************************************/

// Tox::Client#initialize_with
VALUE mTox_cClient_initialize_with(const VALUE self, const VALUE options)
{
  mTox_cClient_CDATA  *self_cdata;
  mTox_cOptions_CDATA *options_cdata;

  if (!rb_funcall(options, rb_intern("is_a?"), 1, mTox_cOptions)) {
    rb_raise(rb_eTypeError, "expected options to be a Tox::Options");
  }

  Data_Get_Struct(self,    mTox_cClient_CDATA,  self_cdata);
  Data_Get_Struct(options, mTox_cOptions_CDATA, options_cdata);

  TOX_ERR_NEW error;

  self_cdata->tox = tox_new(options_cdata, &error);

  switch (error) {
    case TOX_ERR_NEW_OK:
      break;
    case TOX_ERR_NEW_MALLOC:
      rb_raise(rb_eNoMemError, "tox_new() returned TOX_ERR_NEW_MALLOC");
    case TOX_ERR_NEW_LOAD_BAD_FORMAT:
      rb_raise(rb_const_get(mTox_cClient, rb_intern("BadSavedataError")), "savedata format is invalid");
    default:
      rb_raise(rb_eRuntimeError, "tox_new() failed");
  }

  tox_callback_friend_request(self_cdata->tox, on_friend_request);
  tox_callback_friend_message(self_cdata->tox, on_friend_message);

  return self;
}

// Tox::Client#run_loop
VALUE mTox_cClient_run_loop(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  struct timespec delay;

  delay.tv_sec = 0;

  while (rb_funcall(self, rb_intern("running?"), 0)) {
    delay.tv_nsec = tox_iteration_interval(self_cdata->tox) * 1000000;
    nanosleep(&delay, NULL);

    tox_iterate(self_cdata->tox, self);
  }

  return self;
}

/*************************************************************
 * Callbacks
 *************************************************************/

void on_friend_request(
  Tox *const tox,
  const uint8_t *const public_key,
  const uint8_t *const data,
  const size_t length,
  const VALUE self
)
{
  const VALUE ivar_on_friend_request = rb_iv_get(self, "@on_friend_request");

  if (Qnil == ivar_on_friend_request) {
    return;
  }

  rb_funcall(
    ivar_on_friend_request,
    rb_intern("call"),
    2,
    rb_str_new((char*)public_key, TOX_PUBLIC_KEY_SIZE),
    rb_str_new((char*)data, length)
  );
}

void on_friend_message(
  Tox *const tox,
  const uint32_t friend_number,
  const TOX_MESSAGE_TYPE type,
  const uint8_t *const text,
  const size_t length,
  const VALUE self
)
{
  const VALUE ivar_on_friend_message = rb_iv_get(self, "@on_friend_message");

  if (Qnil == ivar_on_friend_message) {
    return;
  }

  rb_funcall(
    ivar_on_friend_message,
    rb_intern("call"),
    2,
    rb_funcall(
      mTox_cFriend,
      rb_intern("new"),
      2,
      self,
      LONG2FIX(friend_number)
    ),
    rb_str_new((char*)text, length)
  );
}
