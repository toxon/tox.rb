#include "tox.h"

// Public methods

static VALUE mTox_cFriend_exist_QUESTION(VALUE self);
static VALUE mTox_cFriend_public_key(VALUE self);
static VALUE mTox_cFriend_send_message(VALUE self, VALUE text);
static VALUE mTox_cFriend_name(VALUE self);
static VALUE mTox_cFriend_status(VALUE self);
static VALUE mTox_cFriend_status_message(VALUE self);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriend_INIT()
{
  // Public methods

  rb_define_method(mTox_cFriend, "exist?",         mTox_cFriend_exist_QUESTION, 0);
  rb_define_method(mTox_cFriend, "exists?",        mTox_cFriend_exist_QUESTION, 0);
  rb_define_method(mTox_cFriend, "public_key",     mTox_cFriend_public_key,     0);
  rb_define_method(mTox_cFriend, "send_message",   mTox_cFriend_send_message,   1);
  rb_define_method(mTox_cFriend, "name",           mTox_cFriend_name,           0);
  rb_define_method(mTox_cFriend, "status",         mTox_cFriend_status,         0);
  rb_define_method(mTox_cFriend, "status_message", mTox_cFriend_status_message, 0);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Friend#exist?
// Tox::Friend#exists?
VALUE mTox_cFriend_exist_QUESTION(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  const bool result = tox_friend_exists(client_cdata->tox, NUM2LONG(number));

  if (result) {
    return Qtrue;
  }
  else {
    return Qfalse;
  }
}

// Tox::Friend#public_key
VALUE mTox_cFriend_public_key(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  uint8_t public_key[TOX_PUBLIC_KEY_SIZE];

  TOX_ERR_FRIEND_GET_PUBLIC_KEY error;

  const bool result = tox_friend_get_public_key(
    client_cdata->tox,
    NUM2LONG(number),
    public_key,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK:
      break;
    case TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_public_key() failed with TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_public_key");
  }

  if (result != true) {
    RAISE_UNKNOWN("tox_friend_get_public_key");
  }

  return rb_funcall(
    mTox_cPublicKey,
    rb_intern("new"),
    1,
    rb_str_new(public_key, TOX_PUBLIC_KEY_SIZE)
  );
}

// Tox::Friend#send_message
VALUE mTox_cFriend_send_message(const VALUE self, const VALUE text)
{
  Check_Type(text, T_STRING);

  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_ADD error;

  const VALUE result = LONG2FIX(tox_friend_send_message(
    client_cdata->tox,
    NUM2LONG(number),
    TOX_MESSAGE_TYPE_NORMAL,
    (uint8_t*)RSTRING_PTR(text),
    RSTRING_LEN(text),
    &error
  ));

  switch (error) {
    case TOX_ERR_FRIEND_SEND_MESSAGE_OK:
      break;
    case TOX_ERR_FRIEND_SEND_MESSAGE_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_NULL"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED:
      rb_raise(
        mTox_cFriend_eNotConnectedError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ:
      rb_raise(
        mTox_mOutMessage_eSendQueueAllocError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG:
      rb_raise(
        mTox_mOutMessage_eTooLongError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY:
      rb_raise(
        mTox_mOutMessage_eEmptyError,
        "tox_friend_send_message() failed with TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY"
      );
    default:
      RAISE_UNKNOWN("tox_friend_send_message");
  }

  return rb_funcall(
    mTox_cFriend_cOutMessage,
    rb_intern("new"),
    2,
    self,
    result
  );
}

// Tox::Friend#name
VALUE mTox_cFriend_name(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_QUERY error;

  const size_t name_size = tox_friend_get_name_size(
    client_cdata->tox,
    NUM2LONG(number),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_get_name_size() failed with TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_name_size() failed with TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_name_size");
  }

  char name[name_size];

  const bool result = tox_friend_get_name(
    client_cdata->tox,
    NUM2LONG(number),
    name,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_get_name() failed with TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_name() failed with TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_name");
  }

  if (result != true) {
    RAISE_UNKNOWN("tox_friend_get_name");
  }

  return rb_str_new(name, name_size);
}

// Tox::Friend#status
VALUE mTox_cFriend_status(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_QUERY error;

  const TOX_USER_STATUS result = tox_friend_get_status(
    client_cdata->tox,
    NUM2LONG(number),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_get_status() failed with TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_status() failed with TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_name");
  }

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

// Tox::Friend#status_message
VALUE mTox_cFriend_status_message(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_QUERY error;

  const size_t status_message_size = tox_friend_get_status_message_size(
    client_cdata->tox,
    NUM2LONG(number),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_get_status_message_size() failed with TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_status_message_size() failed with TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_status_message_size");
  }

  char status_message[status_message_size];

  const bool result = tox_friend_get_status_message(
    client_cdata->tox,
    NUM2LONG(number),
    status_message,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      rb_raise(
        mTox_eNullError,
        "tox_friend_get_status_message() failed with TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      rb_raise(
        mTox_cFriend_eNotFoundError,
        "tox_friend_get_status_message() failed with TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_UNKNOWN("tox_friend_get_status_message");
  }

  if (result != true) {
    RAISE_UNKNOWN("tox_friend_get_status_message");
  }

  return rb_str_new(status_message, status_message_size);
}
