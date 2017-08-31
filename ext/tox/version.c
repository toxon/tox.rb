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

// Singleton methods

static VALUE mTox_mVersion_abi_major(VALUE self);
static VALUE mTox_mVersion_abi_minor(VALUE self);
static VALUE mTox_mVersion_abi_patch(VALUE self);

/*************************************************************
 * Initialization
 *************************************************************/

void mTox_mVersion_INIT()
{
  // Constants

  rb_define_const(mTox_mVersion, "API_MAJOR", LONG2FIX(TOX_VERSION_MAJOR));
  rb_define_const(mTox_mVersion, "API_MINOR", LONG2FIX(TOX_VERSION_MINOR));
  rb_define_const(mTox_mVersion, "API_PATCH", LONG2FIX(TOX_VERSION_PATCH));

  // Singleton methods

  rb_define_singleton_method(mTox_mVersion, "abi_major", mTox_mVersion_abi_major, 0);
  rb_define_singleton_method(mTox_mVersion, "abi_minor", mTox_mVersion_abi_minor, 0);
  rb_define_singleton_method(mTox_mVersion, "abi_patch", mTox_mVersion_abi_patch, 0);
}

// Tox::Version.abi_major
VALUE mTox_mVersion_abi_major(const VALUE self)
{
  return LONG2FIX(tox_version_major());
}

// Tox::Version.abi_minor
VALUE mTox_mVersion_abi_minor(const VALUE self)
{
  return LONG2FIX(tox_version_minor());
}

// Tox::Version.abi_patch
VALUE mTox_mVersion_abi_patch(const VALUE self)
{
  return LONG2FIX(tox_version_patch());
}
