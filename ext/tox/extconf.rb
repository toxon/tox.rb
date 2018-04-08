#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

def cflags(s)
  $CFLAGS += " #{s} "
end

def have_library!(*args)
  exit 1 unless have_library(*args)
end

def have_header!(*args)
  exit 1 unless have_header(*args)
end

def have_struct_member!(*args)
  exit 1 unless have_struct_member(*args)
end

def have_func!(*args)
  exit 1 unless have_func(*args)
end

def have_macro!(*args)
  exit 1 unless have_macro(*args)
end

def have_type!(*args)
  exit 1 unless have_type(*args)
end

def have_const!(*args)
  exit 1 unless have_const(*args)
end

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

have_library! 'toxcore'

have_header! 'ruby.h'
have_header! 'time.h'
have_header! 'tox/tox.h'

have_struct_member! 'struct timespec', 'tv_sec'
have_struct_member! 'struct timespec', 'tv_nsec'

have_func! 'free'
have_func! 'memset'
have_func! 'sprintf'
have_func! 'nanosleep'

have_macro! 'TOX_VERSION_IS_API_COMPATIBLE', 'tox/tox.h'
have_macro! 'TOX_VERSION_IS_ABI_COMPATIBLE', 'tox/tox.h'

have_type! 'TOX_ERR_OPTIONS_NEW',           'tox/tox.h'
have_type! 'TOX_ERR_NEW',                   'tox/tox.h'
have_type! 'TOX_ERR_BOOTSTRAP',             'tox/tox.h'
have_type! 'TOX_ERR_SET_INFO',              'tox/tox.h'
have_type! 'TOX_ERR_FRIEND_ADD',            'tox/tox.h'
have_type! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY', 'tox/tox.h'
have_type! 'TOX_ERR_FRIEND_QUERY',          'tox/tox.h'
have_type! 'TOX_ERR_FRIEND_SEND_MESSAGE',   'tox/tox.h'
have_type! 'TOX_SAVEDATA_TYPE',             'tox/tox.h'
have_type! 'TOX_MESSAGE_TYPE',              'tox/tox.h'
have_type! 'TOX_USER_STATUS',               'tox/tox.h'
have_type! 'tox_friend_request_cb',         'tox/tox.h'
have_type! 'tox_friend_message_cb',         'tox/tox.h'
have_type! 'tox_friend_name_cb',            'tox/tox.h'
have_type! 'tox_friend_status_message_cb',  'tox/tox.h'
have_type! 'tox_friend_status_cb',          'tox/tox.h'

have_struct_member! 'struct Tox_Options', 'savedata_type',   'tox/tox.h'
have_struct_member! 'struct Tox_Options', 'savedata_length', 'tox/tox.h'
have_struct_member! 'struct Tox_Options', 'savedata_data',   'tox/tox.h'

have_const! 'TOX_VERSION_MAJOR',                              'tox/tox.h'
have_const! 'TOX_VERSION_MINOR',                              'tox/tox.h'
have_const! 'TOX_VERSION_PATCH',                              'tox/tox.h'
have_const! 'TOX_HASH_LENGTH',                                'tox/tox.h'
have_const! 'TOX_SAVEDATA_TYPE_NONE',                         'tox/tox.h'
have_const! 'TOX_SAVEDATA_TYPE_TOX_SAVE',                     'tox/tox.h'
have_const! 'TOX_ERR_OPTIONS_NEW_OK',                         'tox/tox.h'
have_const! 'TOX_ERR_OPTIONS_NEW_MALLOC',                     'tox/tox.h'
have_const! 'TOX_ERR_NEW_OK',                                 'tox/tox.h'
have_const! 'TOX_ERR_NEW_NULL',                               'tox/tox.h'
have_const! 'TOX_ERR_NEW_MALLOC',                             'tox/tox.h'
have_const! 'TOX_ERR_NEW_PORT_ALLOC',                         'tox/tox.h'
have_const! 'TOX_ERR_NEW_PROXY_BAD_TYPE',                     'tox/tox.h'
have_const! 'TOX_ERR_NEW_PROXY_BAD_HOST',                     'tox/tox.h'
have_const! 'TOX_ERR_NEW_PROXY_BAD_PORT',                     'tox/tox.h'
have_const! 'TOX_ERR_NEW_PROXY_NOT_FOUND',                    'tox/tox.h'
have_const! 'TOX_ERR_NEW_LOAD_ENCRYPTED',                     'tox/tox.h'
have_const! 'TOX_ERR_NEW_LOAD_BAD_FORMAT',                    'tox/tox.h'
have_const! 'TOX_ADDRESS_SIZE',                               'tox/tox.h'
have_const! 'TOX_PUBLIC_KEY_SIZE',                            'tox/tox.h'
have_const! 'TOX_ERR_BOOTSTRAP_OK',                           'tox/tox.h'
have_const! 'TOX_ERR_BOOTSTRAP_NULL',                         'tox/tox.h'
have_const! 'TOX_ERR_BOOTSTRAP_BAD_HOST',                     'tox/tox.h'
have_const! 'TOX_ERR_BOOTSTRAP_BAD_PORT',                     'tox/tox.h'
have_const! 'TOX_ERR_SET_INFO_OK',                            'tox/tox.h'
have_const! 'TOX_ERR_SET_INFO_NULL',                          'tox/tox.h'
have_const! 'TOX_ERR_SET_INFO_TOO_LONG',                      'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_OK',                          'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_NULL',                        'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_TOO_LONG',                    'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_NO_MESSAGE',                  'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_OWN_KEY',                     'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_ALREADY_SENT',                'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_BAD_CHECKSUM',                'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM',              'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_ADD_MALLOC',                      'tox/tox.h'
have_const! 'TOX_MESSAGE_TYPE_NORMAL',                        'tox/tox.h'
have_const! 'TOX_MESSAGE_TYPE_ACTION',                        'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK',               'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND', 'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_QUERY_OK',                        'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_QUERY_NULL',                      'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND',          'tox/tox.h'
have_const! 'TOX_USER_STATUS_NONE',                           'tox/tox.h'
have_const! 'TOX_USER_STATUS_AWAY',                           'tox/tox.h'
have_const! 'TOX_USER_STATUS_BUSY',                           'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_OK',                 'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_NULL',               'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND',   'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED', 'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ',                'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG',             'tox/tox.h'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY',                'tox/tox.h'

have_func! 'tox_version_major',                       'tox/tox.h'
have_func! 'tox_version_minor',                       'tox/tox.h'
have_func! 'tox_version_patch',                       'tox/tox.h'
have_func! 'tox_version_is_compatible',               'tox/tox.h'
have_func! 'tox_hash',                                'tox/tox.h'
have_func! 'tox_new',                                 'tox/tox.h'
have_func! 'tox_options_default',                     'tox/tox.h'
have_func! 'tox_options_get_ipv6_enabled',            'tox/tox.h'
have_func! 'tox_options_set_ipv6_enabled',            'tox/tox.h'
have_func! 'tox_options_get_udp_enabled',             'tox/tox.h'
have_func! 'tox_options_set_udp_enabled',             'tox/tox.h'
have_func! 'tox_options_get_local_discovery_enabled', 'tox/tox.h'
have_func! 'tox_options_set_local_discovery_enabled', 'tox/tox.h'
have_func! 'tox_options_get_proxy_type',              'tox/tox.h'
have_func! 'tox_options_set_proxy_type',              'tox/tox.h'
have_func! 'tox_options_get_proxy_host',              'tox/tox.h'
have_func! 'tox_options_set_proxy_host',              'tox/tox.h'
have_func! 'tox_options_get_proxy_port',              'tox/tox.h'
have_func! 'tox_options_set_proxy_port',              'tox/tox.h'
have_func! 'tox_options_get_start_port',              'tox/tox.h'
have_func! 'tox_options_set_start_port',              'tox/tox.h'
have_func! 'tox_options_get_end_port',                'tox/tox.h'
have_func! 'tox_options_set_end_port',                'tox/tox.h'
have_func! 'tox_options_get_tcp_port',                'tox/tox.h'
have_func! 'tox_options_set_tcp_port',                'tox/tox.h'
have_func! 'tox_get_savedata_size',                   'tox/tox.h'
have_func! 'tox_get_savedata',                        'tox/tox.h'
have_func! 'tox_self_get_address',                    'tox/tox.h'
have_func! 'tox_self_get_nospam',                     'tox/tox.h'
have_func! 'tox_self_set_nospam',                     'tox/tox.h'
have_func! 'tox_self_get_public_key',                 'tox/tox.h'
have_func! 'tox_self_get_udp_port',                   'tox/tox.h'
have_func! 'tox_self_get_tcp_port',                   'tox/tox.h'
have_func! 'tox_kill',                                'tox/tox.h'
have_func! 'tox_bootstrap',                           'tox/tox.h'
have_func! 'tox_iteration_interval',                  'tox/tox.h'
have_func! 'tox_iterate',                             'tox/tox.h'
have_func! 'tox_friend_add_norequest',                'tox/tox.h'
have_func! 'tox_friend_send_message',                 'tox/tox.h'
have_func! 'tox_callback_friend_request',             'tox/tox.h'
have_func! 'tox_callback_friend_message',             'tox/tox.h'
have_func! 'tox_self_get_name_size',                  'tox/tox.h'
have_func! 'tox_self_get_name',                       'tox/tox.h'
have_func! 'tox_self_set_name',                       'tox/tox.h'
have_func! 'tox_self_get_status_message_size',        'tox/tox.h'
have_func! 'tox_self_get_status_message',             'tox/tox.h'
have_func! 'tox_self_set_status_message',             'tox/tox.h'
have_func! 'tox_self_get_status',                     'tox/tox.h'
have_func! 'tox_self_set_status',                     'tox/tox.h'
have_func! 'tox_self_get_friend_list_size',           'tox/tox.h'
have_func! 'tox_self_get_friend_list',                'tox/tox.h'
have_func! 'tox_friend_exists',                       'tox/tox.h'
have_func! 'tox_friend_get_public_key',               'tox/tox.h'
have_func! 'tox_friend_get_name_size',                'tox/tox.h'
have_func! 'tox_friend_get_name',                     'tox/tox.h'
have_func! 'tox_friend_get_status_message',           'tox/tox.h'
have_func! 'tox_friend_get_status',                   'tox/tox.h'
have_func! 'tox_callback_friend_name',                'tox/tox.h'
have_func! 'tox_callback_friend_status_message',      'tox/tox.h'
have_func! 'tox_callback_friend_status',              'tox/tox.h'

create_makefile 'tox/tox' or exit 1
