#include "tox.h"

/*************************************************************
 * Self callbacks
 *************************************************************/

void on_self_connection_status_change(
  Tox *const tox,
  const TOX_CONNECTION connection_status_data,
  const VALUE self
)
{
  const VALUE ivar_on_self_connection_status_change =
    rb_iv_get(self, "@on_self_connection_status_change");

  if (Qnil == ivar_on_self_connection_status_change) {
    return;
  }

  const VALUE connection_status =
    mTox_mConnectionStatus_FROM_DATA(connection_status_data);

  rb_funcall(
    ivar_on_self_connection_status_change,
    rb_intern("call"),
    1,
    connection_status
  );
}

/*************************************************************
 * Friend callbacks
 *************************************************************/

void on_friend_request(
  Tox *const tox,
  const uint8_t *const public_key_data,
  const uint8_t *const text_data,
  const size_t text_length_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_request = rb_iv_get(self, "@on_friend_request");

  if (Qnil == ivar_on_friend_request) {
    return;
  }

  const VALUE public_key_value =
    rb_str_new(public_key_data, TOX_PUBLIC_KEY_SIZE);

  const VALUE public_key = rb_funcall(mTox_cPublicKey, rb_intern("new"), 1,
                                      public_key_value);

  const VALUE text = rb_str_new(text_data, text_length_data);

  rb_funcall(ivar_on_friend_request, rb_intern("call"), 2,
             public_key,
             text);
}

void on_friend_message(
  Tox *const tox,
  const uint32_t friend_number_data,
  const TOX_MESSAGE_TYPE type,
  const uint8_t *const text_data,
  const size_t text_length_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_message = rb_iv_get(self, "@on_friend_message");

  if (Qnil == ivar_on_friend_message) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend = rb_funcall(mTox_cFriend, rb_intern("new"), 2,
                                  self,
                                  friend_number);

  const VALUE text = rb_str_new(text_data, text_length_data);

  rb_funcall(ivar_on_friend_message, rb_intern("call"), 2,
             friend,
             text);
}

void on_friend_name_change(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint8_t *const name_data,
  const size_t name_length_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_name_change =
    rb_iv_get(self, "@on_friend_name_change");

  if (Qnil == ivar_on_friend_name_change) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend = rb_funcall(mTox_cFriend, rb_intern("new"), 2,
                                  self,
                                  friend_number);

  const VALUE name = rb_str_new(name_data, name_length_data);

  rb_funcall(ivar_on_friend_name_change, rb_intern("call"), 2,
             friend,
             name);
}

void on_friend_status_message_change(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint8_t *const status_message_data,
  size_t status_message_length_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_status_message_change =
    rb_iv_get(self, "@on_friend_status_message_change");

  if (Qnil == ivar_on_friend_status_message_change) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend = rb_funcall(mTox_cFriend, rb_intern("new"), 2,
                                  self,
                                  friend_number);

  const VALUE status_message =
    rb_str_new(status_message_data, status_message_length_data);

  rb_funcall(ivar_on_friend_status_message_change, rb_intern("call"), 2,
             friend,
             status_message);
}

void on_friend_status_change(
  Tox *const tox,
  const uint32_t friend_number_data,
  const TOX_USER_STATUS status_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_status_change =
    rb_iv_get(self, "@on_friend_status_change");

  if (Qnil == ivar_on_friend_status_change) {
    return;
  }

  const VALUE status = mTox_mUserStatus_TRY_DATA(status_data);

  if (status == Qnil) {
    return;
  }

  const VALUE friend_number = LONG2FIX(friend_number_data);

  const VALUE friend = rb_funcall(mTox_cFriend, rb_intern("new"), 2,
                                  self,
                                  friend_number);

  rb_funcall(ivar_on_friend_status_change, rb_intern("call"), 2,
             friend,
             status);
}

void on_friend_connection_status_change(
  Tox *const tox,
  const uint32_t friend_number_data,
  const TOX_CONNECTION connection_status_data,
  const VALUE self
)
{
  const VALUE ivar_on_friend_connection_status_change =
    rb_iv_get(self, "@on_friend_connection_status_change");

  if (Qnil == ivar_on_friend_connection_status_change) {
    return;
  }

  const VALUE friend_number = ULONG2NUM(friend_number_data);

  const VALUE friend = rb_funcall(
    mTox_cFriend,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE connection_status =
    mTox_mConnectionStatus_FROM_DATA(connection_status_data);

  rb_funcall(
    ivar_on_friend_connection_status_change,
    rb_intern("call"),
    2,
    friend,
    connection_status
  );
}

/*************************************************************
 * File callbacks
 *************************************************************/

void on_file_chunk_request(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint32_t file_number_data,
  const uint64_t position_data,
  const size_t length_data,
  const VALUE self
)
{
  const VALUE ivar_on_file_chunk_request =
    rb_iv_get(self, "@on_file_chunk_request");

  if (Qnil == ivar_on_file_chunk_request) {
    return;
  }

  const VALUE friend_number = ULONG2NUM(friend_number_data);
  const VALUE file_number   = ULONG2NUM(file_number_data);
  const VALUE position      = ULL2NUM(position_data);
  const VALUE length        = LONG2NUM(length_data);

  const VALUE friend = rb_funcall(
    mTox_cFriend,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE out_friend_file = rb_funcall(
    mTox_cOutFriendFile,
    rb_intern("new"),
    2,
    friend,
    file_number
  );

  rb_funcall(
    ivar_on_file_chunk_request,
    rb_intern("call"),
    3,
    out_friend_file,
    position,
    length
  );
}

void on_file_recv_request(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint32_t file_number_data,
  const enum TOX_FILE_KIND file_kind_data,
  const uint64_t file_size_data,
  const uint8_t *const filename_data,
  const size_t filename_length_data,
  const VALUE self
)
{
  const VALUE ivar_on_file_recv_request =
    rb_iv_get(self, "@on_file_recv_request");

  if (Qnil == ivar_on_file_recv_request) {
    return;
  }

  const VALUE friend_number = ULONG2NUM(friend_number_data);
  const VALUE file_number   = ULONG2NUM(file_number_data);
  const VALUE file_size     = ULL2NUM(file_size_data);

  const VALUE file_kind = mTox_mFileKind_TRY_DATA(file_kind_data);

  if (Qnil == file_kind) {
    return;
  }

  const VALUE filename = rb_str_new(filename_data, filename_length_data);

  const VALUE friend = rb_funcall(
    mTox_cFriend,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE in_friend_file = rb_funcall(
    mTox_cInFriendFile,
    rb_intern("new"),
    2,
    friend,
    file_number
  );

  rb_funcall(
    ivar_on_file_recv_request,
    rb_intern("call"),
    4,
    in_friend_file,
    file_kind,
    file_size,
    filename
  );
}

void on_file_recv_chunk(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint32_t file_number_data,
  const uint64_t position_data,
  const uint8_t *const ptr_data,
  const size_t length_data,
  const VALUE self
)
{
  const VALUE ivar_on_file_recv_chunk = rb_iv_get(self, "@on_file_recv_chunk");

  if (Qnil == ivar_on_file_recv_chunk) {
    return;
  }

  const VALUE friend_number = ULONG2NUM(friend_number_data);
  const VALUE file_number   = ULONG2NUM(file_number_data);
  const VALUE position      = ULL2NUM(position_data);

  const VALUE data = rb_str_new(ptr_data, length_data);

  const VALUE friend = rb_funcall(
    mTox_cFriend,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE in_friend_file = rb_funcall(
    mTox_cInFriendFile,
    rb_intern("new"),
    2,
    friend,
    file_number
  );

  rb_funcall(
    ivar_on_file_recv_chunk,
    rb_intern("call"),
    3,
    in_friend_file,
    position,
    data
  );
}

void on_file_recv_control(
  Tox *const tox,
  const uint32_t friend_number_data,
  const uint32_t file_number_data,
  const TOX_FILE_CONTROL file_control_data,
  const VALUE self
)
{
  const VALUE ivar_on_file_recv_control =
    rb_iv_get(self, "@on_file_recv_control");

  if (Qnil == ivar_on_file_recv_control) {
    return;
  }

  const VALUE file_control = mTox_mFileControl_TRY_DATA(file_control_data);

  if (Qnil == file_control) {
    return;
  }

  const VALUE friend_number = ULONG2NUM(friend_number_data);
  const VALUE file_number   = ULONG2NUM(file_number_data);

  const VALUE friend = rb_funcall(
    mTox_cFriend,
    rb_intern("new"),
    2,
    self,
    friend_number
  );

  const VALUE in_friend_file = rb_funcall(
    mTox_cInFriendFile,
    rb_intern("new"),
    2,
    friend,
    file_number
  );

  rb_funcall(
    ivar_on_file_recv_control,
    rb_intern("call"),
    2,
    in_friend_file,
    file_control
  );
}
