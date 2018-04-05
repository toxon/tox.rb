#include "tox.h"

#include <time.h>

// Memory management
static VALUE mTox_cClient_alloc(VALUE klass);
static void  mTox_cClient_free(mTox_cClient_CDATA *free_cdata);

// Public methods

static VALUE mTox_cClient_public_key(VALUE self);
static VALUE mTox_cClient_address(VALUE self);
static VALUE mTox_cClient_nospam(VALUE self);
static VALUE mTox_cClient_nospam_ASSIGN(VALUE self, VALUE nospam);
static VALUE mTox_cClient_savedata(VALUE self);

static VALUE mTox_cClient_bootstrap(VALUE self, VALUE node);

static VALUE mTox_cClient_name(VALUE self);
static VALUE mTox_cClient_name_ASSIGN(VALUE self, VALUE name);

static VALUE mTox_cClient_status(VALUE self);
static VALUE mTox_cClient_status_ASSIGN(VALUE self, VALUE status);

static VALUE mTox_cClient_status_message(VALUE self);
static VALUE mTox_cClient_status_message_ASSIGN(VALUE self, VALUE status_message);

static VALUE mTox_cClient_friend_numbers(VALUE self);

static VALUE mTox_cClient_friend_add_norequest(VALUE self, VALUE public_key);
static VALUE mTox_cClient_friend_add(VALUE self, VALUE address, VALUE text);

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

static void on_friend_name_change(
  Tox *tox,
  uint32_t friend_number,
  const uint8_t *name,
  size_t length,
  VALUE self
);

static void on_friend_status_message_change(
  Tox *tox,
  uint32_t friend_number,
  const uint8_t *status_message,
  size_t length,
  VALUE self
);

static void on_friend_status_change(
  Tox *tox,
  uint32_t friend_number,
  TOX_USER_STATUS status,
  VALUE self
);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cClient_INIT()
{
  // Memory management
  rb_define_alloc_func(mTox_cClient, mTox_cClient_alloc);

  // Public methods

  rb_define_method(mTox_cClient, "public_key", mTox_cClient_public_key,    0);
  rb_define_method(mTox_cClient, "address",    mTox_cClient_address,       0);
  rb_define_method(mTox_cClient, "nospam",     mTox_cClient_nospam,        0);
  rb_define_method(mTox_cClient, "nospam=",    mTox_cClient_nospam_ASSIGN, 1);
  rb_define_method(mTox_cClient, "savedata",   mTox_cClient_savedata,      0);

  rb_define_method(mTox_cClient, "bootstrap", mTox_cClient_bootstrap, 1);

  rb_define_method(mTox_cClient, "name",  mTox_cClient_name,        0);
  rb_define_method(mTox_cClient, "name=", mTox_cClient_name_ASSIGN, 1);

  rb_define_method(mTox_cClient, "status",  mTox_cClient_status,        0);
  rb_define_method(mTox_cClient, "status=", mTox_cClient_status_ASSIGN, 1);

  rb_define_method(mTox_cClient, "status_message",  mTox_cClient_status_message,        0);
  rb_define_method(mTox_cClient, "status_message=", mTox_cClient_status_message_ASSIGN, 1);

  rb_define_method(mTox_cClient, "friend_numbers", mTox_cClient_friend_numbers, 0);

  rb_define_method(mTox_cClient, "friend_add_norequest", mTox_cClient_friend_add_norequest, 1);
  rb_define_method(mTox_cClient, "friend_add",           mTox_cClient_friend_add,           2);

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

// Tox::Client#public_key
VALUE mTox_cClient_public_key(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  char public_key[TOX_PUBLIC_KEY_SIZE];

  tox_self_get_public_key(self_cdata->tox, (uint8_t*)public_key);

  return rb_funcall(
    mTox_cPublicKey,
    rb_intern("new"),
    1,
    rb_str_new(public_key, TOX_PUBLIC_KEY_SIZE)
  );
}

// Tox::Client#address
VALUE mTox_cClient_address(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  char address[TOX_ADDRESS_SIZE];

  tox_self_get_address(self_cdata->tox, (uint8_t*)address);

  return rb_funcall(
    mTox_cAddress,
    rb_intern("new"),
    1,
    rb_str_new(address, TOX_ADDRESS_SIZE)
  );
}

// Tox::Client#nospam
VALUE mTox_cClient_nospam(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  uint32_t nospam = tox_self_get_nospam(self_cdata->tox);

  return rb_funcall(
    mTox_cNospam,
    rb_intern("new"),
    1,
    LONG2FIX(nospam)
  );
}

// Tox::Client#nospam
VALUE mTox_cClient_nospam_ASSIGN(const VALUE self, const VALUE nospam)
{
  if (!rb_funcall(nospam, rb_intern("is_a?"), 1, mTox_cNospam)) {
    RAISE_TYPECHECK("Tox::Client#nospam=", "nospam", "Tox::Nospam");
  }

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  tox_self_set_nospam(
    self_cdata->tox,
    FIX2LONG(rb_funcall(nospam, rb_intern("to_i"), 0))
  );

  return Qnil;
}

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

// Tox::Client#bootstrap
VALUE mTox_cClient_bootstrap(const VALUE self, const VALUE node)
{
  if (!rb_funcall(node, rb_intern("is_a?"), 1, mTox_cNode)) {
    RAISE_TYPECHECK("Tox::Client#bootstrap", "node", "Tox::Node");
  }

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_BOOTSTRAP error;

  tox_bootstrap(
    self_cdata->tox,
    RSTRING_PTR(rb_funcall(node, rb_intern("resolv_ipv4"), 0)),
    NUM2INT(rb_funcall(node, rb_intern("port"), 0)),
    RSTRING_PTR(rb_funcall(rb_funcall(node, rb_intern("public_key"), 0), rb_intern("value"), 0)),
    &error
  );

  switch (error) {
    case TOX_ERR_BOOTSTRAP_OK:
      return Qtrue;
    case TOX_ERR_BOOTSTRAP_NULL:
      return Qfalse;
    case TOX_ERR_BOOTSTRAP_BAD_HOST:
      return Qfalse;
    case TOX_ERR_BOOTSTRAP_BAD_PORT:
      return Qfalse;
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
VALUE mTox_cClient_name_ASSIGN(const VALUE self, const VALUE name)
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
    case TOX_ERR_SET_INFO_NULL:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_self_set_name",
        "TOX_ERR_SET_INFO_NULL"
      );
    case TOX_ERR_SET_INFO_TOO_LONG:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_self_set_name",
        "TOX_ERR_SET_INFO_TOO_LONG"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_self_set_name");
  }

  if (!result) {
    RAISE_FUNC_RESULT("tox_self_set_name");
  }

  return name;
}

// Tox::Client#status
VALUE mTox_cClient_status(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const TOX_USER_STATUS result = tox_self_get_status(self_cdata->tox);

  switch (result) {
    case TOX_USER_STATUS_NONE:
      return mTox_mUserStatus_NONE;
    case TOX_USER_STATUS_AWAY:
      return mTox_mUserStatus_AWAY;
    case TOX_USER_STATUS_BUSY:
      return mTox_mUserStatus_BUSY;
    default:
      RAISE_ENUM("TOX_USER_STATUS");
  }
}

// Tox::Client#status=
VALUE mTox_cClient_status_ASSIGN(const VALUE self, const VALUE status)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  if (rb_funcall(mTox_mUserStatus_NONE, rb_intern("=="), 1, status)) {
    tox_self_set_status(self_cdata->tox, TOX_USER_STATUS_NONE);
  }
  else if (rb_funcall(mTox_mUserStatus_AWAY, rb_intern("=="), 1, status)) {
    tox_self_set_status(self_cdata->tox, TOX_USER_STATUS_AWAY);
  }
  else if (rb_funcall(mTox_mUserStatus_BUSY, rb_intern("=="), 1, status)) {
    tox_self_set_status(self_cdata->tox, TOX_USER_STATUS_BUSY);
  }
  else {
    rb_raise(rb_eArgError, "invalid value for Tox::Client#status=");
  }

  return status;
}

// Tox::Client#status_message
VALUE mTox_cClient_status_message(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const size_t status_message_size = tox_self_get_status_message_size(self_cdata->tox);

  char status_message[status_message_size];

  if (status_message_size > 0) {
    tox_self_get_status_message(self_cdata->tox, (uint8_t*)status_message);
  }

  return rb_str_new(status_message, status_message_size);
}

// Tox::Client#status_message=
VALUE mTox_cClient_status_message_ASSIGN(const VALUE self, const VALUE status_message)
{
  Check_Type(status_message, T_STRING);

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_SET_INFO error;

  const bool result = tox_self_set_status_message(
    self_cdata->tox,
    (uint8_t**)RSTRING_PTR(status_message),
    RSTRING_LEN(status_message),
    &error
  );

  switch (error) {
    case TOX_ERR_SET_INFO_OK:
      break;
    case TOX_ERR_SET_INFO_NULL:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_self_set_status_message",
        "TOX_ERR_SET_INFO_NULL"
      );
    case TOX_ERR_SET_INFO_TOO_LONG:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_self_set_status_message",
        "TOX_ERR_SET_INFO_TOO_LONG"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_self_set_status_message");
  }

  if (!result) {
    RAISE_FUNC_RESULT("tox_self_set_status_message");
  }

  return status_message;
}

// Tox::Client#friend_numbers
VALUE mTox_cClient_friend_numbers(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const size_t friend_numbers_size = tox_self_get_friend_list_size(self_cdata->tox);

  if (friend_numbers_size == 0) {
    return rb_ary_new();
  }

  uint32_t friend_numbers[friend_numbers_size];

  tox_self_get_friend_list(self_cdata->tox, friend_numbers);

  VALUE friend_number_values[friend_numbers_size];

  for (unsigned long i = 0; i < friend_numbers_size; ++i) {
    friend_number_values[i] = LONG2NUM(friend_numbers[i]);
  }

  return rb_ary_new4(friend_numbers_size, friend_number_values);
}

// Tox::Client#friend_add_norequest
VALUE mTox_cClient_friend_add_norequest(const VALUE self, const VALUE public_key)
{
  if (!rb_funcall(public_key, rb_intern("is_a?"), 1, mTox_cPublicKey)) {
    RAISE_TYPECHECK("Tox::Client#friend_add_norequest", "public_key", "Tox::PublicKey");
  }

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_FRIEND_ADD error;

  const VALUE friend_number = LONG2FIX(tox_friend_add_norequest(
    self_cdata->tox,
    (uint8_t*)RSTRING_PTR(rb_funcall(public_key, rb_intern("value"), 0)),
    &error
  ));

  switch (error) {
    case TOX_ERR_FRIEND_ADD_OK:
      break;
    case TOX_ERR_FRIEND_ADD_NULL:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_NULL"
      );
    case TOX_ERR_FRIEND_ADD_OWN_KEY:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_OWN_KEY"
      );
    case TOX_ERR_FRIEND_ADD_ALREADY_SENT:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_ALREADY_SENT"
      );
    case TOX_ERR_FRIEND_ADD_BAD_CHECKSUM:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_BAD_CHECKSUM"
      );
    case TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM"
      );
    case TOX_ERR_FRIEND_ADD_MALLOC:
      RAISE_FUNC_ERROR(
        rb_eNoMemError,
        "tox_friend_add_norequest",
        "TOX_ERR_FRIEND_ADD_MALLOC"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_add_norequest");
  }

  return rb_funcall(
    self,
    rb_intern("friend"),
    1,
    friend_number
  );
}

// Tox::Client#friend_add
VALUE mTox_cClient_friend_add(const VALUE self, const VALUE address, const VALUE text)
{
  if (!rb_funcall(address, rb_intern("is_a?"), 1, mTox_cAddress)) {
    RAISE_TYPECHECK("Tox::Client#friend_add", "address", "Tox::Address");
  }

  Check_Type(text, T_STRING);

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_FRIEND_ADD error;

  const VALUE friend_number = LONG2FIX(tox_friend_add(
    self_cdata->tox,
    (uint8_t*)RSTRING_PTR(rb_funcall(address, rb_intern("value"), 0)),
    (uint8_t*)RSTRING_PTR(text),
    RSTRING_LEN(text),
    &error
  ));

  switch (error) {
    case TOX_ERR_FRIEND_ADD_OK:
      break;
    case TOX_ERR_FRIEND_ADD_NULL:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_NULL"
      );
    case TOX_ERR_FRIEND_ADD_NO_MESSAGE:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_NO_MESSAGE"
      );
    case TOX_ERR_FRIEND_ADD_TOO_LONG:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_TOO_LONG"
      );
    case TOX_ERR_FRIEND_ADD_OWN_KEY:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_OWN_KEY"
      );
    case TOX_ERR_FRIEND_ADD_ALREADY_SENT:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_ALREADY_SENT"
      );
    case TOX_ERR_FRIEND_ADD_BAD_CHECKSUM:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_BAD_CHECKSUM"
      );
    case TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM"
      );
    case TOX_ERR_FRIEND_ADD_MALLOC:
      RAISE_FUNC_ERROR(
        rb_eNoMemError,
        "tox_friend_add",
        "TOX_ERR_FRIEND_ADD_MALLOC"
      );
  }

  return rb_funcall(
    self,
    rb_intern("friend"),
    1,
    friend_number
  );
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
    RAISE_TYPECHECK("Tox::Client#initialize_with", "options", "Tox::Options");
  }

  Data_Get_Struct(self,    mTox_cClient_CDATA,  self_cdata);
  Data_Get_Struct(options, mTox_cOptions_CDATA, options_cdata);

  TOX_ERR_NEW error;

  self_cdata->tox = tox_new(options_cdata, &error);

  switch (error) {
    case TOX_ERR_NEW_OK:
      break;
    case TOX_ERR_NEW_NULL:
      RAISE_FUNC_ERROR(
        mTox_eNullError,
        "tox_new",
        "TOX_ERR_NEW_NULL"
      );
    case TOX_ERR_NEW_MALLOC:
      RAISE_FUNC_ERROR(
        rb_eNoMemError,
        "tox_new",
        "TOX_ERR_NEW_MALLOC"
      );
    case TOX_ERR_NEW_PORT_ALLOC:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_PORT_ALLOC"
      );
    case TOX_ERR_NEW_PROXY_BAD_TYPE:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_PROXY_BAD_TYPE"
      );
    case TOX_ERR_NEW_PROXY_BAD_HOST:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_PROXY_BAD_HOST"
      );
    case TOX_ERR_NEW_PROXY_BAD_PORT:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_PROXY_BAD_PORT"
      );
    case TOX_ERR_NEW_PROXY_NOT_FOUND:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_PROXY_NOT_FOUND"
      );
    case TOX_ERR_NEW_LOAD_ENCRYPTED:
      RAISE_FUNC_ERROR(
        rb_eRuntimeError,
        "tox_new",
        "TOX_ERR_NEW_LOAD_ENCRYPTED"
      );
    case TOX_ERR_NEW_LOAD_BAD_FORMAT:
      RAISE_FUNC_ERROR(
        mTox_cClient_eBadSavedataError,
        "tox_new",
        "TOX_ERR_NEW_LOAD_BAD_FORMAT"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_new");
  }

  tox_callback_friend_request       (self_cdata->tox, on_friend_request);
  tox_callback_friend_message       (self_cdata->tox, on_friend_message);
  tox_callback_friend_name          (self_cdata->tox, on_friend_name_change);
  tox_callback_friend_status_message(self_cdata->tox, on_friend_status_message_change);
  tox_callback_friend_status        (self_cdata->tox, on_friend_status_change);

  return self;
}

// Tox::Client#run_loop
VALUE mTox_cClient_run_loop(const VALUE self)
{
  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  struct timespec delay;

  delay.tv_sec = 0;

  const VALUE ivar_on_iteration = rb_iv_get(self, "@on_iteration");

  while (rb_funcall(self, rb_intern("running?"), 0)) {
    delay.tv_nsec = tox_iteration_interval(self_cdata->tox) * 1000000;
    nanosleep(&delay, NULL);

    tox_iterate(self_cdata->tox, self);

    if (Qnil != ivar_on_iteration) {
      rb_funcall(ivar_on_iteration, rb_intern("call"), 0);
    }
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
    rb_funcall(
      mTox_cPublicKey,
      rb_intern("new"),
      1,
      rb_str_new(public_key, TOX_PUBLIC_KEY_SIZE)
    ),
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

void on_friend_name_change(
  Tox *const tox,
  const uint32_t friend_number,
  const uint8_t *const name,
  const size_t length,
  const VALUE self
)
{
  const VALUE ivar_on_friend_name_change = rb_iv_get(self, "@on_friend_name_change");

  if (Qnil == ivar_on_friend_name_change) {
    return;
  }

  rb_funcall(
    ivar_on_friend_name_change,
    rb_intern("call"),
    2,
    rb_funcall(
      mTox_cFriend,
      rb_intern("new"),
      2,
      self,
      LONG2FIX(friend_number)
    ),
    rb_str_new(name, length)
  );
}

void on_friend_status_message_change(
  Tox *const tox,
  const uint32_t friend_number,
  const uint8_t *const status_message,
  size_t length,
  const VALUE self
)
{
  const VALUE ivar_on_friend_status_message_change = rb_iv_get(self, "@on_friend_status_message_change");

  if (Qnil == ivar_on_friend_status_message_change) {
    return;
  }

  rb_funcall(
    ivar_on_friend_status_message_change,
    rb_intern("call"),
    2,
    rb_funcall(
      mTox_cFriend,
      rb_intern("new"),
      2,
      self,
      LONG2FIX(friend_number)
    ),
    rb_str_new(status_message, length)
  );
}

void on_friend_status_change(
  Tox *const tox,
  const uint32_t friend_number,
  const TOX_USER_STATUS status,
  const VALUE self
)
{
  const VALUE ivar_on_friend_status_change = rb_iv_get(self, "@on_friend_status_change");

  if (Qnil == ivar_on_friend_status_change) {
    return;
  }

  VALUE status_value;

  switch (status) {
    case TOX_USER_STATUS_NONE:
      status_value = mTox_mUserStatus_NONE;
      break;
    case TOX_USER_STATUS_AWAY:
      status_value = mTox_mUserStatus_AWAY;
      break;
    case TOX_USER_STATUS_BUSY:
      status_value = mTox_mUserStatus_BUSY;
      break;
    default:
      return;
  }

  rb_funcall(
    ivar_on_friend_status_change,
    rb_intern("call"),
    2,
    rb_funcall(
      mTox_cFriend,
      rb_intern("new"),
      2,
      self,
      LONG2FIX(friend_number)
    ),
    status_value
  );
}
