/*
 * tox.rb - Ruby interface for libtoxcore
 * Copyright (C) 2015-2017  Braiden Vasco
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

#include "friend.h"
#include "tox.h"
#include "client.h"

// Public methods

static VALUE mTox_cFriend_send_message(VALUE self, VALUE text);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_cFriend_INIT()
{
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

  TOX_ERR_FRIEND_ADD error;

  const result = tox_friend_send_message(
    client_cdata->tox,
    NUM2LONG(number),
    TOX_MESSAGE_TYPE_NORMAL,
    (uint8_t*)RSTRING_PTR(text),
    RSTRING_LEN(text),
    &error
  );

  switch (error) {
    case TOX_ERR_FRIEND_SEND_MESSAGE_OK:
      break;
    case TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ:
      rb_raise(rb_eNoMemError, "tox_friend_send_message() returned TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ");
    default:
      rb_raise(rb_eRuntimeError, "tox_friend_send_message() failed");
  }

  return LONG2FIX(result);
}
