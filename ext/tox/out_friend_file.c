#include "tox.h"

// Public methods

static VALUE mTox_cOutFriendFile_send_chunk(VALUE self, VALUE position, VALUE data);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cOutFriendFile_INIT()
{
  // Public methods

  rb_define_method(mTox_cOutFriendFile, "send_chunk", mTox_cOutFriendFile_send_chunk, 2);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::OutFriendFile#send_chunk
VALUE mTox_cOutFriendFile_send_chunk(
 const VALUE self,
 const VALUE position,
 const VALUE data
)
{
  Check_Type(data, T_STRING);

  const VALUE friend      = rb_iv_get(self, "@friend");
  const VALUE file_number = rb_iv_get(self, "@number");

  const VALUE client        = rb_iv_get(friend, "@client");
  const VALUE friend_number = rb_iv_get(friend, "@number");

  CDATA(client, mTox_cClient_CDATA, client_cdata);

  const uint32_t friend_number_data = NUM2ULONG(friend_number);
  const uint32_t file_number_data   = NUM2ULONG(file_number);
  const uint64_t position_data      = NUM2ULL(position);

  const uint8_t *ptr_data  = RSTRING_PTR(data);
  const size_t length_data = RSTRING_LEN(data);

  TOX_ERR_FILE_SEND_CHUNK tox_file_send_chunk_error;

  const bool tox_file_send_chunk_result = tox_file_send_chunk(
    client_cdata->tox,
    friend_number_data,
    file_number_data,
    position_data,
    ptr_data,
    length_data,
    &tox_file_send_chunk_error
  );

  switch (tox_file_send_chunk_error) {
    case TOX_ERR_FILE_SEND_CHUNK_OK:
      break;
    case TOX_ERR_FILE_SEND_CHUNK_NULL:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        mTox_eNullError,
        "TOX_ERR_FILE_SEND_CHUNK_NULL"
      );
    case TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_FOUND"
      );
    case TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_CONNECTED:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        mTox_cFriend_eNotConnectedError,
        "TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_CONNECTED"
      );
    case TOX_ERR_FILE_SEND_CHUNK_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        rb_eRuntimeError,
        "TOX_ERR_FILE_SEND_CHUNK_NOT_FOUND"
      );
    case TOX_ERR_FILE_SEND_CHUNK_NOT_TRANSFERRING:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        rb_eRuntimeError,
        "TOX_ERR_FILE_SEND_CHUNK_NOT_TRANSFERRING"
      );
    case TOX_ERR_FILE_SEND_CHUNK_INVALID_LENGTH:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        rb_eRuntimeError,
        "TOX_ERR_FILE_SEND_CHUNK_INVALID_LENGTH"
      );
    case TOX_ERR_FILE_SEND_CHUNK_SENDQ:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        rb_eRuntimeError,
        "TOX_ERR_FILE_SEND_CHUNK_SENDQ"
      );
    case TOX_ERR_FILE_SEND_CHUNK_WRONG_POSITION:
      RAISE_FUNC_ERROR(
        "tox_file_send_chunk",
        rb_eRuntimeError,
        "TOX_ERR_FILE_SEND_CHUNK_WRONG_POSITION"
      );
    default:
      RAISE_FUNC_ERROR_DEFAULT("tox_file_send_chunk");
  }

  if (!tox_file_send_chunk_result) {
    RAISE_FUNC_RESULT("tox_file_send_chunk");
  }

  return Qnil;
}
