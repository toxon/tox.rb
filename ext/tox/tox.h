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

#include <ruby.h>

#include <tox/tox.h>

// C extension initialization

void Init_tox();
void mTox_cOptions_INIT();
void mTox_cClient_INIT();
void mTox_cFriend_INIT();

// C data

typedef struct Tox_Options mTox_cOptions_CDATA;

typedef struct {
  Tox *tox;
} mTox_cClient_CDATA;

// Instances

extern VALUE mTox;

extern VALUE mTox_eNullError;
extern VALUE mTox_eUnknownError;
extern VALUE mTox_eUnknownSecurityError;

extern VALUE mTox_mUserStatus;
extern VALUE mTox_cOptions;
extern VALUE mTox_cClient;
extern VALUE mTox_cNode;
extern VALUE mTox_cFriend;
extern VALUE mTox_cAddress;
extern VALUE mTox_cPublicKey;
extern VALUE mTox_mOutMessage;

extern VALUE mTox_mUserStatus_NONE;
extern VALUE mTox_mUserStatus_AWAY;
extern VALUE mTox_mUserStatus_BUSY;

extern VALUE mTox_cClient_eBadSavedataError;

extern VALUE mTox_cFriend_eNotFoundError;
extern VALUE mTox_cFriend_eNotConnectedError;
extern VALUE mTox_cFriend_cOutMessage;

extern VALUE mTox_mOutMessage_eSendQueueAllocError;
extern VALUE mTox_mOutMessage_eTooLongError;
extern VALUE mTox_mOutMessage_eEmptyError;
