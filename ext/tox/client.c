/*
 * tox.rb - Ruby interface for libtoxcore
 * Copyright (C) 2015-2018  Braiden Vasco
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "tox.h"

#include <time.h>

// Memory management
static VALUE mTox_cClient_alloc(VALUE klass);
static void  mTox_cClient_free(mTox_cClient_CDATA *free_cdata);

// Public methods

static VALUE mTox_cClient_public_key(VALUE self);
static VALUE mTox_cClient_address(VALUE self);
static VALUE mTox_cClient_savedata(VALUE self);

static VALUE mTox_cClient_bootstrap(VALUE self, VALUE node);

static VALUE mTox_cClient_name(VALUE self);
static VALUE mTox_cClient_name_EQUALS(VALUE self, VALUE name);

static VALUE mTox_cClient_status(VALUE self);
static VALUE mTox_cClient_status_EQUALS(VALUE self, VALUE status);

static VALUE mTox_cClient_status_message(VALUE self);
static VALUE mTox_cClient_status_message_EQUALS(VALUE self, VALUE status_message);

static VALUE mTox_cClient_friend_numbers(VALUE self);

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

  rb_define_method(mTox_cClient, "public_key", mTox_cClient_public_key, 0);
  rb_define_method(mTox_cClient, "address",    mTox_cClient_address,    0);
  rb_define_method(mTox_cClient, "savedata",   mTox_cClient_savedata,   0);

  rb_define_method(mTox_cClient, "bootstrap", mTox_cClient_bootstrap, 1);

  rb_define_method(mTox_cClient, "name",  mTox_cClient_name,        0);
  rb_define_method(mTox_cClient, "name=", mTox_cClient_name_EQUALS, 1);

  rb_define_method(mTox_cClient, "status",  mTox_cClient_status,        0);
  rb_define_method(mTox_cClient, "status=", mTox_cClient_status_EQUALS, 1);

  rb_define_method(mTox_cClient, "status_message",  mTox_cClient_status_message,        0);
  rb_define_method(mTox_cClient, "status_message=", mTox_cClient_status_message_EQUALS, 1);

  rb_define_method(mTox_cClient, "friend_numbers", mTox_cClient_friend_numbers, 0);

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
    rb_raise(rb_eTypeError, "expected argument 1 to be a Tox::Node");
  }

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  TOX_ERR_BOOTSTRAP error;

  tox_bootstrap(self_cdata->tox,
                RSTRING_PTR(rb_funcall(node, rb_intern("resolv_ipv4"), 0)),
                NUM2INT(rb_funcall(node, rb_intern("port"), 0)),
                RSTRING_PTR(rb_funcall(node, rb_intern("public_key"), 0)),
                &error);

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
    case TOX_ERR_SET_INFO_NULL:
      rb_raise(mTox_eNullError, "tox_self_set_name() failed with TOX_ERR_SET_INFO_NULL");
    case TOX_ERR_SET_INFO_TOO_LONG:
      rb_raise(rb_eRuntimeError, "tox_self_set_name() failed with TOX_ERR_SET_INFO_TOO_LONG");
    default:
      rb_raise(mTox_eUnknownError, "tox_self_set_name() failed");
  }

  if (!result) {
    rb_raise(mTox_eUnknownError, "tox_self_set_name() failed");
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
      rb_raise(rb_eNotImpError, "Tox::Client#status has unknown value");
  }
}

// Tox::Client#status=
VALUE mTox_cClient_status_EQUALS(const VALUE self, const VALUE status)
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
VALUE mTox_cClient_status_message_EQUALS(const VALUE self, const VALUE status_message)
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
      rb_raise(mTox_eNullError, "tox_self_set_status_message() failed with TOX_ERR_SET_INFO_NULL");
    case TOX_ERR_SET_INFO_TOO_LONG:
      rb_raise(rb_eRuntimeError, "tox_self_set_status_message() failed with TOX_ERR_SET_INFO_TOO_LONG");
    default:
      rb_raise(mTox_eUnknownError, "tox_self_set_status_message() failed");
  }

  if (!result) {
    rb_raise(mTox_eUnknownError, "tox_self_set_status_message() failed");
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
  Check_Type(public_key, T_STRING);

  mTox_cClient_CDATA *self_cdata;

  Data_Get_Struct(self, mTox_cClient_CDATA, self_cdata);

  const VALUE friend_number = LONG2FIX(tox_friend_add_norequest(
    self_cdata->tox,
    (uint8_t*)RSTRING_PTR(public_key),
    NULL
  ));

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
    rb_raise(rb_eTypeError, "expected options to be a Tox::Options");
  }

  Data_Get_Struct(self,    mTox_cClient_CDATA,  self_cdata);
  Data_Get_Struct(options, mTox_cOptions_CDATA, options_cdata);

  TOX_ERR_NEW error;

  self_cdata->tox = tox_new(options_cdata, &error);

  switch (error) {
    case TOX_ERR_NEW_OK:
      break;
    case TOX_ERR_NEW_NULL:
      rb_raise(mTox_eNullError, "tox_new() failed with TOX_ERR_NEW_NULL");
    case TOX_ERR_NEW_MALLOC:
      rb_raise(rb_eNoMemError, "tox_new() failed with TOX_ERR_NEW_MALLOC");
    case TOX_ERR_NEW_PORT_ALLOC:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_PORT_ALLOC");
    case TOX_ERR_NEW_PROXY_BAD_TYPE:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_PROXY_BAD_TYPE");
    case TOX_ERR_NEW_PROXY_BAD_HOST:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_PROXY_BAD_HOST");
    case TOX_ERR_NEW_PROXY_BAD_PORT:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_PROXY_BAD_PORT");
    case TOX_ERR_NEW_PROXY_NOT_FOUND:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_PROXY_NOT_FOUND");
    case TOX_ERR_NEW_LOAD_ENCRYPTED:
      rb_raise(rb_eRuntimeError, "tox_new() failed with TOX_ERR_NEW_LOAD_ENCRYPTED");
    case TOX_ERR_NEW_LOAD_BAD_FORMAT:
      rb_raise(mTox_cClient_eBadSavedataError, "tox_new() failed with TOX_ERR_NEW_LOAD_BAD_FORMAT");
    default:
      rb_raise(mTox_eUnknownError, "tox_new() failed");
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
