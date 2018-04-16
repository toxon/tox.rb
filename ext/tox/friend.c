#include "tox.h"

// Public methods

static VALUE mTox_cFriend_exist_QUESTION(VALUE self);
static VALUE mTox_cFriend_public_key(VALUE self);
static VALUE mTox_cFriend_send_message(VALUE self, VALUE text);
static VALUE mTox_cFriend_name(VALUE self);
static VALUE mTox_cFriend_status(VALUE self);
static VALUE mTox_cFriend_status_message(VALUE self);
static VALUE mTox_cFriend_send_file(VALUE self, VALUE file_kind, VALUE file_size, VALUE filename);

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
  rb_define_method(mTox_cFriend, "send_file",      mTox_cFriend_send_file,      3);
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

  CDATA(client, mTox_cClient_CDATA, client_cdata)

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

  CDATA(client, mTox_cClient_CDATA, client_cdata);

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

  CDATA(client, mTox_cClient_CDATA, client_cdata);

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
    rb_funcall(mTox_cOutFriendMessage, rb_intern("new"), 2,
               self,
               result);

  return friend_out_message;
}

// Tox::Friend#name
VALUE mTox_cFriend_name(const VALUE self)
{
  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  CDATA(client, mTox_cClient_CDATA, client_cdata);

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

  CDATA(client, mTox_cClient_CDATA, client_cdata);

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

  CDATA(client, mTox_cClient_CDATA, client_cdata);

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

// Tox::Friend#send_file
VALUE mTox_cFriend_send_file(const VALUE self, const VALUE file_kind, const VALUE file_size, const VALUE filename)
{
  const enum TOX_FILE_KIND file_kind_data = mTox_mFileKind_TO_DATA(file_kind);

  const uint64_t file_size_data =
    file_size == Qnil
    ? UINT64_MAX
    : NUM2ULL(file_size);

  Check_Type(filename, T_STRING);

  const VALUE client = rb_iv_get(self, "@client");

  CDATA(client, mTox_cClient_CDATA, client_cdata);

  const VALUE friend_number = rb_iv_get(self, "@number");

  const uint32_t friend_number_data = NUM2ULONG(friend_number);

  TOX_ERR_FILE_SEND file_send_error;

  const uint32_t file_number_data = tox_file_send(
    client_cdata->tox,
    friend_number_data,
    file_kind_data,
    file_size_data,
    NULL,
    RSTRING_PTR(filename),
    RSTRING_LEN(filename),
    &file_send_error
  );

  switch (file_send_error) {
    case TOX_ERR_FILE_SEND_OK:
      break;
    case TOX_ERR_FILE_SEND_NULL:
      RAISE_FUNC_ERROR(
        "tox_file_send",
        mTox_eNullError,
        "TOX_ERR_FILE_SEND_NULL"
      );
    case TOX_ERR_FILE_SEND_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_file_send",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FILE_SEND_FRIEND_NOT_FOUND"
      );
    case TOX_ERR_FILE_SEND_FRIEND_NOT_CONNECTED:
      RAISE_FUNC_ERROR(
        "tox_file_send",
        mTox_cFriend_eNotConnectedError,
        "TOX_ERR_FILE_SEND_FRIEND_NOT_CONNECTED"
      );
    case TOX_ERR_FILE_SEND_NAME_TOO_LONG:
      RAISE_FUNC_ERROR(
        "tox_file_send",
        mTox_cOutFriendFile_eNameTooLongError,
        "TOX_ERR_FILE_SEND_NAME_TOO_LONG"
      );
    case TOX_ERR_FILE_SEND_TOO_MANY:
      RAISE_FUNC_ERROR(
        "tox_file_send",
        mTox_cOutFriendFile_eTooManyError,
        "TOX_ERR_FILE_SEND_TOO_MANY"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_file_send");
  }

  if (file_number_data == UINT32_MAX) {
    RAISE_FUNC_RESULT("tox_file_send");
  }

  const VALUE file_number = LONG2FIX(file_number_data);

  const VALUE friend_out_file =
    rb_funcall(mTox_cOutFriendFile, rb_intern("new"), 2,
               self,
               file_number);

  return friend_out_file;
}
