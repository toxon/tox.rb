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

void Init_tox();

// Instances

extern VALUE mTox;

extern VALUE mTox_cOptions;
extern VALUE mTox_cClient;
extern VALUE mTox_cNode;
extern VALUE mTox_cFriend;
extern VALUE mTox_cAddress;

extern VALUE mTox_cClient_eBadSavedataError;
