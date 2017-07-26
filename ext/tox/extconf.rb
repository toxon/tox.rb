#!/usr/bin/env ruby
# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'mkmf'

def cflags(s)
  $CFLAGS += " #{s} "
end

cflags '-std=c99'
cflags '-Wall'
cflags '-Wextra'

have_library 'toxcore' and

have_header 'ruby.h' and
have_header 'time.h' and
have_header 'tox/tox.h' and

have_struct_member 'struct timespec', 'tv_sec'  and
have_struct_member 'struct timespec', 'tv_nsec' and

have_func 'free' and
have_func 'memset' and
have_func 'sprintf' and
have_func 'nanosleep' and

have_macro 'TOX_VERSION_IS_API_COMPATIBLE', 'tox/tox.h' and
have_macro 'TOX_VERSION_IS_ABI_COMPATIBLE', 'tox/tox.h' and

have_type 'TOX_ERR_NEW',                   'tox/tox.h' and
have_type 'TOX_ERR_BOOTSTRAP',             'tox/tox.h' and
have_type 'TOX_ERR_SET_INFO',              'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_GET_PUBLIC_KEY', 'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_QUERY',          'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_SEND_MESSAGE',   'tox/tox.h' and
have_type 'TOX_MESSAGE_TYPE',              'tox/tox.h' and
have_type 'TOX_USER_STATUS',               'tox/tox.h' and
have_type 'tox_friend_request_cb',         'tox/tox.h' and
have_type 'tox_friend_message_cb',         'tox/tox.h' and
have_type 'tox_friend_name_cb',            'tox/tox.h' and
have_type 'tox_friend_status_message_cb',  'tox/tox.h' and
have_type 'tox_friend_status_cb',          'tox/tox.h' and

have_struct_member 'struct Tox_Options', 'savedata_type',   'tox/tox.h' and
have_struct_member 'struct Tox_Options', 'savedata_length', 'tox/tox.h' and
have_struct_member 'struct Tox_Options', 'savedata_data',   'tox/tox.h' and

have_const 'TOX_HASH_LENGTH',                                'tox/tox.h' and
have_const 'TOX_SAVEDATA_TYPE_NONE',                         'tox/tox.h' and
have_const 'TOX_SAVEDATA_TYPE_TOX_SAVE',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_OK',                                 'tox/tox.h' and
have_const 'TOX_ERR_NEW_MALLOC',                             'tox/tox.h' and
have_const 'TOX_ERR_NEW_LOAD_BAD_FORMAT',                    'tox/tox.h' and
have_const 'TOX_ADDRESS_SIZE',                               'tox/tox.h' and
have_const 'TOX_PUBLIC_KEY_SIZE',                            'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_OK',                           'tox/tox.h' and
have_const 'TOX_ERR_SET_INFO_OK',                            'tox/tox.h' and
have_const 'TOX_MESSAGE_TYPE_NORMAL',                        'tox/tox.h' and
have_const 'TOX_MESSAGE_TYPE_ACTION',                        'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK',               'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND', 'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_QUERY_OK',                        'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_QUERY_NULL',                      'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND',          'tox/tox.h' and
have_const 'TOX_USER_STATUS_NONE',                           'tox/tox.h' and
have_const 'TOX_USER_STATUS_AWAY',                           'tox/tox.h' and
have_const 'TOX_USER_STATUS_BUSY',                           'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_OK',                 'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_NULL',               'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND',   'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED', 'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ',                'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG',             'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY',                'tox/tox.h' and

have_func 'tox_version_is_compatible',        'tox/tox.h' and
have_func 'tox_hash',                         'tox/tox.h' and
have_func 'tox_new',                          'tox/tox.h' and
have_func 'tox_options_default',              'tox/tox.h' and
have_func 'tox_get_savedata_size',            'tox/tox.h' and
have_func 'tox_get_savedata',                 'tox/tox.h' and
have_func 'tox_self_get_address',             'tox/tox.h' and
have_func 'tox_self_get_public_key',          'tox/tox.h' and
have_func 'tox_kill',                         'tox/tox.h' and
have_func 'tox_bootstrap',                    'tox/tox.h' and
have_func 'tox_iteration_interval',           'tox/tox.h' and
have_func 'tox_iterate',                      'tox/tox.h' and
have_func 'tox_friend_add_norequest',         'tox/tox.h' and
have_func 'tox_friend_send_message',          'tox/tox.h' and
have_func 'tox_callback_friend_request',      'tox/tox.h' and
have_func 'tox_callback_friend_message',      'tox/tox.h' and
have_func 'tox_self_get_name_size',           'tox/tox.h' and
have_func 'tox_self_get_name',                'tox/tox.h' and
have_func 'tox_self_set_name',                'tox/tox.h' and
have_func 'tox_self_get_status_message_size', 'tox/tox.h' and
have_func 'tox_self_get_status_message',      'tox/tox.h' and
have_func 'tox_self_set_status_message',      'tox/tox.h' and
have_func 'tox_self_get_status',              'tox/tox.h' and
have_func 'tox_self_set_status',              'tox/tox.h' and
have_func 'tox_self_get_friend_list_size',    'tox/tox.h' and
have_func 'tox_self_get_friend_list',         'tox/tox.h' and
have_func 'tox_friend_exists',                'tox/tox.h' and
have_func 'tox_friend_get_public_key',        'tox/tox.h' and
have_func 'tox_friend_get_name_size',         'tox/tox.h' and
have_func 'tox_friend_get_name',              'tox/tox.h' and
have_func 'tox_friend_get_status_message',    'tox/tox.h' and
have_func 'tox_friend_get_status',            'tox/tox.h' and
have_func 'tox_callback_friend_name',         'tox/tox.h' and
have_func 'tox_callback_friend_status_message', 'tox/tox.h' and
have_func 'tox_callback_friend_status',         'tox/tox.h' and

create_makefile 'tox/tox' or exit 1
