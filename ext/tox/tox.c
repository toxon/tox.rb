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
#include "options.h"
#include "client.h"
#include "friend.h"

#if !(TOX_VERSION_IS_API_COMPATIBLE(0, 1, 9))
  #error "Tox API version is not compatible"
#endif

// Instances

VALUE mTox;

VALUE mTox_cOptions;
VALUE mTox_cClient;
VALUE mTox_cNode;
VALUE mTox_cFriend;
VALUE mTox_cAddress;

VALUE mTox_cClient_eBadSavedataError;

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

  mTox_cOptions = rb_const_get(mTox, rb_intern("Options"));
  mTox_cClient  = rb_const_get(mTox, rb_intern("Client"));
  mTox_cNode    = rb_const_get(mTox, rb_intern("Node"));
  mTox_cFriend  = rb_const_get(mTox, rb_intern("Friend"));
  mTox_cAddress = rb_const_get(mTox, rb_intern("Address"));

  mTox_cClient_eBadSavedataError = rb_const_get(mTox_cClient, rb_intern("BadSavedataError"));

  mTox_cOptions_INIT();
  mTox_cClient_INIT();
  mTox_cFriend_INIT();
}
