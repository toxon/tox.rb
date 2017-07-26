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

#include "tox.h"

#if !(TOX_VERSION_IS_API_COMPATIBLE(0, 1, 9))
  #error "Tox API version is not compatible"
#endif

// Instances

VALUE mTox;

VALUE mTox_mUserStatus;
VALUE mTox_cOptions;
VALUE mTox_cClient;
VALUE mTox_cNode;
VALUE mTox_cFriend;
VALUE mTox_cAddress;
VALUE mTox_cPublicKey;

VALUE mTox_mUserStatus_NONE;
VALUE mTox_mUserStatus_AWAY;
VALUE mTox_mUserStatus_BUSY;

VALUE mTox_cClient_eBadSavedataError;

VALUE mTox_cFriend_eNotFoundError;
VALUE mTox_cFriend_eNotConnectedError;

// Singleton methods

static VALUE mTox_hash(VALUE self, VALUE data);

/*************************************************************
 * Initialization
 *************************************************************/

void Init_tox()
{
  if (!TOX_VERSION_IS_ABI_COMPATIBLE()) {
    rb_raise(rb_eLoadError, "incompatible Tox ABI version");
  }

  // Instances

  mTox = rb_const_get(rb_cObject, rb_intern("Tox"));

  mTox_mUserStatus = rb_const_get(mTox, rb_intern("UserStatus"));
  mTox_cOptions    = rb_const_get(mTox, rb_intern("Options"));
  mTox_cClient     = rb_const_get(mTox, rb_intern("Client"));
  mTox_cNode       = rb_const_get(mTox, rb_intern("Node"));
  mTox_cFriend     = rb_const_get(mTox, rb_intern("Friend"));
  mTox_cAddress    = rb_const_get(mTox, rb_intern("Address"));
  mTox_cPublicKey  = rb_const_get(mTox, rb_intern("PublicKey"));

  mTox_mUserStatus_NONE = rb_const_get(mTox_mUserStatus, rb_intern("NONE"));
  mTox_mUserStatus_AWAY = rb_const_get(mTox_mUserStatus, rb_intern("AWAY"));
  mTox_mUserStatus_BUSY = rb_const_get(mTox_mUserStatus, rb_intern("BUSY"));

  mTox_cClient_eBadSavedataError = rb_const_get(mTox_cClient, rb_intern("BadSavedataError"));

  mTox_cFriend_eNotFoundError     = rb_const_get(mTox_cFriend, rb_intern("NotFoundError"));
  mTox_cFriend_eNotConnectedError = rb_const_get(mTox_cFriend, rb_intern("NotConnectedError"));

  // Singleton methods

  rb_define_singleton_method(mTox, "hash", mTox_hash, 1);

  mTox_cOptions_INIT();
  mTox_cClient_INIT();
  mTox_cFriend_INIT();
}

/*************************************************************
 * Singleton methods
 *************************************************************/

// Tox.hash
VALUE mTox_hash(const VALUE self, const VALUE data)
{
  Check_Type(data, T_STRING);

  const uint8_t result[TOX_HASH_LENGTH];

  if (true != tox_hash(result, (const uint8_t*)RSTRING_PTR(data), RSTRING_LEN(data))) {
    rb_raise(rb_eSecurityError, "tox_hash() failed");
  }

  return rb_str_new(result, TOX_HASH_LENGTH);
}
