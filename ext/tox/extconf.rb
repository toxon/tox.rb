#!/usr/bin/env ruby
# frozen_string_literal: true

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

have_type 'TOX_ERR_NEW',           'tox/tox.h' and
have_type 'TOX_ERR_BOOTSTRAP',     'tox/tox.h' and
have_type 'TOX_MESSAGE_TYPE',      'tox/tox.h' and
have_type 'tox_friend_request_cb', 'tox/tox.h' and
have_type 'tox_friend_message_cb', 'tox/tox.h' and

have_struct_member 'struct Tox_Options', 'savedata_type',   'tox/tox.h' and
have_struct_member 'struct Tox_Options', 'savedata_length', 'tox/tox.h' and
have_struct_member 'struct Tox_Options', 'savedata_data',   'tox/tox.h' and

have_const 'TOX_SAVEDATA_TYPE_NONE',      'tox/tox.h' and
have_const 'TOX_SAVEDATA_TYPE_TOX_SAVE',  'tox/tox.h' and
have_const 'TOX_ERR_NEW_OK',              'tox/tox.h' and
have_const 'TOX_ERR_NEW_MALLOC',          'tox/tox.h' and
have_const 'TOX_ERR_NEW_LOAD_BAD_FORMAT', 'tox/tox.h' and
have_const 'TOX_ADDRESS_SIZE',            'tox/tox.h' and
have_const 'TOX_PUBLIC_KEY_SIZE',         'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_OK',        'tox/tox.h' and
have_const 'TOX_MESSAGE_TYPE_NORMAL',     'tox/tox.h' and

have_func 'tox_version_is_compatible',   'tox/tox.h' and
have_func 'tox_new',                     'tox/tox.h' and
have_func 'tox_options_default',         'tox/tox.h' and
have_func 'tox_get_savedata_size',       'tox/tox.h' and
have_func 'tox_get_savedata',            'tox/tox.h' and
have_func 'tox_self_get_address',        'tox/tox.h' and
have_func 'tox_kill',                    'tox/tox.h' and
have_func 'tox_bootstrap',               'tox/tox.h' and
have_func 'tox_iteration_interval',      'tox/tox.h' and
have_func 'tox_iterate',                 'tox/tox.h' and
have_func 'tox_friend_add_norequest',    'tox/tox.h' and
have_func 'tox_friend_send_message',     'tox/tox.h' and
have_func 'tox_callback_friend_request', 'tox/tox.h' and
have_func 'tox_callback_friend_message', 'tox/tox.h' and

create_makefile 'tox/tox' or exit 1
