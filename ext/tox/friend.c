#include "friend.h"
#include "tox.h"
#include "client.h"

// Instance
VALUE mTox_cFriend;

// Public methods
static VALUE mTox_cFriend_send_message(VALUE self, VALUE text);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriend_INIT()
{
  mTox_cFriend = rb_define_class_under(mTox, "Friend", rb_cObject);

  // Public methods
  rb_define_method(mTox_cFriend, "send_message", mTox_cFriend_send_message, 1);
}

/*************************************************************
 * Public methods
 *************************************************************/

// Tox::Friend#send_message
VALUE mTox_cFriend_send_message(const VALUE self, const VALUE text)
{
  Check_Type(text, T_STRING);

  const VALUE client = rb_iv_get(self, "@client");
  const VALUE number = rb_iv_get(self, "@number");

  mTox_cClient_CDATA *client_cdata;

  Data_Get_Struct(client, mTox_cClient_CDATA, client_cdata);

  return LONG2FIX(tox_friend_send_message(
    client_cdata->tox,
    NUM2LONG(number),
    TOX_MESSAGE_TYPE_NORMAL,
    (uint8_t*)RSTRING_PTR(text),
    RSTRING_LEN(text),
    NULL
  ));
}
