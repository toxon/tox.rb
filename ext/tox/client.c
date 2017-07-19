#include "tox.h"
#include "client.h"
#include "options.h"
#include "node.h"

#include <time.h>

// Instance
VALUE mTox_cClient;

// Memory management
static VALUE mTox_cClient_alloc(VALUE klass);
static void  mTox_cClient_free(void *ptr);

// Public methods
static VALUE mTox_cClient_savedata(VALUE self);
static VALUE mTox_cClient_id(VALUE self);
static VALUE mTox_cClient_kill(VALUE self);
static VALUE mTox_cClient_bootstrap(VALUE self, VALUE node);
static VALUE mTox_cClient_friend_add_norequest(VALUE self, VALUE public_key);
static VALUE mTox_cClient_friend_send_message(VALUE self, VALUE friend_number, VALUE text);

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
  rb_define_method(mTox_cClient, "kill",                 mTox_cClient_kill,                 0);
  rb_define_method(mTox_cClient, "bootstrap",            mTox_cClient_bootstrap,            1);
  rb_define_method(mTox_cClient, "friend_add_norequest", mTox_cClient_friend_add_norequest, 1);
  rb_define_method(mTox_cClient, "friend_send_message",  mTox_cClient_friend_send_message,  2);

  // Private methods
  rb_define_private_method(mTox_cClient, "initialize_with", mTox_cClient_initialize_with, 1);
  rb_define_private_method(mTox_cClient, "run_loop",        mTox_cClient_run_loop,        0);
}

/*************************************************************
 * Memory management
 *************************************************************/

VALUE mTox_cClient_alloc(const VALUE klass)
{
  mTox_cClient_ *tox;

  tox = ALLOC(mTox_cClient_);

  return Data_Wrap_Struct(klass, NULL, mTox_cClient_free, tox);
}

void mTox_cClient_free(void *const ptr)
{
  free(ptr);
}

/*************************************************************
 * Public methods
 *************************************************************/

VALUE mTox_cClient_savedata(const VALUE self)
{
  mTox_cClient_ *tox;

  size_t data_size;
  char *data;

  Data_Get_Struct(self, mTox_cClient_, tox);

  data_size = tox_get_savedata_size(tox->tox);
  data = ALLOC_N(char, data_size);

  tox_get_savedata(tox->tox, (uint8_t*)data);

  return rb_str_new(data, data_size);
}

VALUE mTox_cClient_id(const VALUE self)
{
  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  char address[TOX_ADDRESS_SIZE];

  tox_self_get_address(tox->tox, (uint8_t*)address);

  char id[2 * TOX_ADDRESS_SIZE];

  for (unsigned long i = 0; i < TOX_ADDRESS_SIZE; ++i) {
    sprintf(&id[2 * i], "%02X", address[i] & 0xFF);
  }

  return rb_str_new(id, 2 * TOX_ADDRESS_SIZE);
}

VALUE mTox_cClient_kill(const VALUE self)
{
  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  tox_kill(tox->tox);

  return self;
}

VALUE mTox_cClient_bootstrap(const VALUE self, const VALUE node)
{
  if (Qtrue != rb_funcall(node, rb_intern("is_a?"), 1, mTox_cNode)) {
    rb_raise(rb_eTypeError, "expected argument 1 to be a Tox::Node");
  }

  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  const char *const public_key = RSTRING_PTR(rb_funcall(node, rb_intern("public_key"), 0));

  uint8_t public_key_bin[TOX_PUBLIC_KEY_SIZE];

  for (long i = 0; i < TOX_PUBLIC_KEY_SIZE; ++i) {
    sscanf(&public_key[i * 2], "%2hhx", &public_key_bin[i]);
  }

  TOX_ERR_BOOTSTRAP error;

  tox_bootstrap(tox->tox,
                RSTRING_PTR(rb_funcall(node, rb_intern("ipv4"), 0)),
                NUM2INT(rb_funcall(node, rb_intern("port"), 0)),
                public_key_bin,
                &error);

  if (error == TOX_ERR_BOOTSTRAP_OK) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

VALUE mTox_cClient_friend_add_norequest(const VALUE self, const VALUE public_key)
{
  Check_Type(public_key, T_STRING);

  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  return LONG2FIX(tox_friend_add_norequest(tox->tox, (uint8_t*)RSTRING_PTR(public_key), NULL));
}

VALUE mTox_cClient_friend_send_message(const VALUE self, const VALUE friend_number, const VALUE text)
{
  Check_Type(friend_number, T_FIXNUM);
  Check_Type(text, T_STRING);

  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  return LONG2FIX(tox_friend_send_message(
    tox->tox,
    NUM2LONG(friend_number),
    TOX_MESSAGE_TYPE_NORMAL,
    (uint8_t*)RSTRING_PTR(text),
    RSTRING_LEN(text),
    NULL
  ));
}

/*************************************************************
 * Private methods
 *************************************************************/

VALUE mTox_cClient_initialize_with(const VALUE self, const VALUE options)
{
  mTox_cClient_  *tox;
  mTox_cOptions_ *tox_options;

  if (Qfalse == rb_funcall(options, rb_intern("is_a?"), 1, mTox_cOptions)) {
    rb_raise(rb_eTypeError, "expected options to be a Tox::Options");
  }

  Data_Get_Struct(self,    mTox_cClient_,  tox);
  Data_Get_Struct(options, mTox_cOptions_, tox_options);

  TOX_ERR_NEW error;

  tox->tox = tox_new(tox_options, &error);

  if (error != TOX_ERR_NEW_OK) {
    rb_raise(rb_eRuntimeError, "tox_new() failed");
  }

  tox_callback_friend_request(tox->tox, (tox_friend_request_cb*)on_friend_request, (void*)self);
  tox_callback_friend_message(tox->tox, (tox_friend_message_cb*)on_friend_message, (void*)self);

  return self;
}

VALUE mTox_cClient_run_loop(const VALUE self)
{
  mTox_cClient_ *tox;

  Data_Get_Struct(self, mTox_cClient_, tox);

  struct timespec delay;

  delay.tv_sec = 0;

  while (rb_funcall(self, rb_intern("running?"), 0)) {
    delay.tv_nsec = tox_iteration_interval(tox->tox) * 1000000;
    nanosleep(&delay, NULL);

    tox_iterate(tox->tox);
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
    LONG2FIX(friend_number),
    rb_str_new((char*)text, length)
  );
}
