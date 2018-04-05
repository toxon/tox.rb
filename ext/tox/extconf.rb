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

have_type 'TOX_ERR_NEW',                   'tox/tox.h' and
have_type 'TOX_ERR_BOOTSTRAP',             'tox/tox.h' and
have_type 'TOX_ERR_SET_INFO',              'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_ADD',            'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_GET_PUBLIC_KEY', 'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_QUERY',          'tox/tox.h' and
have_type 'TOX_ERR_FRIEND_SEND_MESSAGE',   'tox/tox.h' and
have_type 'TOX_SAVEDATA_TYPE',             'tox/tox.h' and
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

have_const 'TOX_VERSION_MAJOR',                              'tox/tox.h' and
have_const 'TOX_VERSION_MINOR',                              'tox/tox.h' and
have_const 'TOX_VERSION_PATCH',                              'tox/tox.h' and
have_const 'TOX_HASH_LENGTH',                                'tox/tox.h' and
have_const 'TOX_SAVEDATA_TYPE_NONE',                         'tox/tox.h' and
have_const 'TOX_SAVEDATA_TYPE_TOX_SAVE',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_OK',                                 'tox/tox.h' and
have_const 'TOX_ERR_NEW_NULL',                               'tox/tox.h' and
have_const 'TOX_ERR_NEW_MALLOC',                             'tox/tox.h' and
have_const 'TOX_ERR_NEW_PORT_ALLOC',                         'tox/tox.h' and
have_const 'TOX_ERR_NEW_PROXY_BAD_TYPE',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_PROXY_BAD_HOST',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_PROXY_BAD_PORT',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_PROXY_NOT_FOUND',                    'tox/tox.h' and
have_const 'TOX_ERR_NEW_LOAD_ENCRYPTED',                     'tox/tox.h' and
have_const 'TOX_ERR_NEW_LOAD_BAD_FORMAT',                    'tox/tox.h' and
have_const 'TOX_ADDRESS_SIZE',                               'tox/tox.h' and
have_const 'TOX_PUBLIC_KEY_SIZE',                            'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_OK',                           'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_NULL',                         'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_BAD_HOST',                     'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_BAD_PORT',                     'tox/tox.h' and
have_const 'TOX_ERR_SET_INFO_OK',                            'tox/tox.h' and
have_const 'TOX_ERR_SET_INFO_NULL',                          'tox/tox.h' and
have_const 'TOX_ERR_SET_INFO_TOO_LONG',                      'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_OK',                          'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_NULL',                        'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_TOO_LONG',                    'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_NO_MESSAGE',                  'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_OWN_KEY',                     'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_ALREADY_SENT',                'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_BAD_CHECKSUM',                'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM',              'tox/tox.h' and
have_const 'TOX_ERR_FRIEND_ADD_MALLOC',                      'tox/tox.h' and
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

have_func 'tox_version_major',                'tox/tox.h' and
have_func 'tox_version_minor',                'tox/tox.h' and
have_func 'tox_version_patch',                'tox/tox.h' and
have_func 'tox_version_is_compatible',        'tox/tox.h' and
have_func 'tox_hash',                         'tox/tox.h' and
have_func 'tox_new',                          'tox/tox.h' and
have_func 'tox_options_default',              'tox/tox.h' and
have_func 'tox_get_savedata_size',            'tox/tox.h' and
have_func 'tox_get_savedata',                 'tox/tox.h' and
have_func 'tox_self_get_address',             'tox/tox.h' and
have_func 'tox_self_get_nospam',              'tox/tox.h' and
have_func 'tox_self_set_nospam',              'tox/tox.h' and
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
