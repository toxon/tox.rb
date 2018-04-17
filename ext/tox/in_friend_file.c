#include "tox.h"

// Public methods

static VALUE mTox_cInFriendFile_control(VALUE self, VALUE file_control);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cInFriendFile_INIT()
{
  // Public methods

  rb_define_method(mTox_cInFriendFile, "control", mTox_cInFriendFile_control, 1);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::InFriendFile#control
VALUE mTox_cInFriendFile_control(
  const VALUE self,
  const VALUE file_control
)
{
  const enum TOX_FILE_CONTROL file_control_data =
    mTox_mFileControl_TO_DATA(file_control);

  const VALUE friend      = rb_iv_get(self, "@friend");
  const VALUE file_number = rb_iv_get(self, "@number");

  const VALUE client        = rb_iv_get(friend, "@client");
  const VALUE friend_number = rb_iv_get(friend, "@number");

  CDATA(client, mTox_cClient_CDATA, client_cdata);

  const uint32_t friend_number_data = NUM2ULONG(friend_number);
  const uint32_t file_number_data   = NUM2ULONG(file_number);

  TOX_ERR_FILE_CONTROL tox_file_control_error;

  const bool tox_file_control_result = tox_file_control(
    client_cdata->tox,
    friend_number_data,
    file_number_data,
    file_control_data,
    &tox_file_control_error
  );

  switch (tox_file_control_error) {
    case TOX_ERR_FILE_CONTROL_OK:
      break;
    case TOX_ERR_FILE_CONTROL_FRIEND_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        mTox_cFriend_eNotFoundError,
        "TOX_ERR_FILE_CONTROL_FRIEND_NOT_FOUND"
      );
    case TOX_ERR_FILE_CONTROL_FRIEND_NOT_CONNECTED:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        mTox_cFriend_eNotConnectedError,
        "TOX_ERR_FILE_CONTROL_FRIEND_NOT_CONNECTED"
      );
    case TOX_ERR_FILE_CONTROL_NOT_FOUND:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        rb_eRuntimeError,
        "TOX_ERR_FILE_CONTROL_NOT_FOUND"
      );
    case TOX_ERR_FILE_CONTROL_NOT_PAUSED:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        rb_eRuntimeError,
        "TOX_ERR_FILE_CONTROL_NOT_PAUSED"
      );
    case TOX_ERR_FILE_CONTROL_DENIED:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        rb_eRuntimeError,
        "TOX_ERR_FILE_CONTROL_DENIED"
      );
    case TOX_ERR_FILE_CONTROL_ALREADY_PAUSED:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        rb_eRuntimeError,
        "TOX_ERR_FILE_CONTROL_ALREADY_PAUSED"
      );
    case TOX_ERR_FILE_CONTROL_SENDQ:
      RAISE_FUNC_ERROR(
        "tox_file_control",
        mTox_eSendQueueError,
        "TOX_ERR_FILE_CONTROL_SENDQ"
      );
  }

  if (!tox_file_control_result) {
    RAISE_FUNC_RESULT("tox_file_control");
  }

  return Qnil;
}
