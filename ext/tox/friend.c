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

  uint8_t public_key_data[TOX_PUBLIC_KEY_SIZE];

  TOX_ERR_FRIEND_GET_PUBLIC_KEY error;

  const bool result = tox_friend_get_public_key(
    client_cdata->tox,
    NUM2LONG(number),
    public_key_data,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK:
      break;
    case TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_public_key",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_public_key");
  }

  if (result != true) {
    RAISE_FUNC_RESULT("tox_friend_get_public_key");
  }

  const VALUE public_key_value =
    rb_str_new(public_key_data, TOX_PUBLIC_KEY_SIZE);

  const VALUE public_key = rb_funcall(mTox_cPublicKey, rb_intern("new"), 1,
                                      public_key_value);

  return public_key;
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
    RSTRING_PTR(text),
    RSTRING_LEN(text),
    &error
  ));

  switch (error) {
    case TOX_ERR_FRIEND_SEND_MESSAGE_OK:
      break;
    case TOX_ERR_FRIEND_SEND_MESSAGE_NULL:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_eNullError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_NULL"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_cFriend_eNotConnectedError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_mOutMessage_eSendQueueAllocError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_mOutMessage_eTooLongError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG"
      );
    case TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY:
      RAISE_FUNC_ERROR(
        "tox_friend_send_message",
        mTox_mOutMessage_eEmptyError,
        "TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_send_message");
  }

  const VALUE friend_out_message =
    rb_funcall(mTox_cFriend_cOutMessage, rb_intern("new"), 2,
               self,
               result);
}

// Tox::Friend#name
VALUE mTox_cFriend_name(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_QUERY error;

  const size_t name_size_data = tox_friend_get_name_size(
    client_cdata->tox,
    NUM2LONG(number),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      RAISE_FUNC_ERROR(
        "tox_friend_get_name_size",
        mTox_eNullError,
        "TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_name_size",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_name_size");
  }

  char name_data[name_size_data];

  const bool result = tox_friend_get_name(
    client_cdata->tox,
    NUM2LONG(number),
    name_data,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      RAISE_FUNC_ERROR(
        "tox_friend_get_name",
        mTox_eNullError,
        "TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_name",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_name");
  }

  if (result != true) {
    RAISE_FUNC_RESULT("tox_friend_get_name");
  }

  const VALUE name = rb_str_new(name_data, name_size_data);

  return name;
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
      RAISE_FUNC_ERROR(
        "tox_friend_get_status",
        mTox_eNullError,
        "TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_status",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_name");
  }

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

// Tox::Friend#status_message
VALUE mTox_cFriend_status_message(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  TOX_ERR_FRIEND_QUERY error;

  const size_t status_message_size_data = tox_friend_get_status_message_size(
    client_cdata->tox,
    NUM2LONG(number),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      RAISE_FUNC_ERROR(
        "tox_friend_get_status_message_size",
        mTox_eNullError,
        "TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_status_message_size",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_status_message_size");
  }

  char status_message_data[status_message_size_data];

  const bool result = tox_friend_get_status_message(
    client_cdata->tox,
    NUM2LONG(number),
    status_message_data,
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_QUERY_OK:
      break;
    case TOX_ERR_FRIEND_QUERY_NULL:
      RAISE_FUNC_ERROR(
        "tox_friend_get_status_message",
        mTox_eNullError,
        "TOX_ERR_FRIEND_QUERY_NULL"
      );
    case TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_friend_get_status_message",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_friend_get_status_message");
  }

  if (result != true) {
    RAISE_FUNC_RESULT("tox_friend_get_status_message");
  }

  const VALUE status_message =
    rb_str_new(status_message_data, status_message_size_data);

  return status_message;
}
