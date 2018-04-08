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
  exit 1 unless have_struct_member(*args, 'tox/tox.h')
end

def have_func!(*args)
  exit 1 unless have_func(*args, 'tox/tox.h')
end

def have_macro!(*args)
  exit 1 unless have_macro(*args, 'tox/tox.h')
end

def have_type!(*args)
  exit 1 unless have_type(*args, 'tox/tox.h')
end

def have_const!(*args)
  exit 1 unless have_const(*args, 'tox/tox.h')
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

have_macro! 'TOX_VERSION_IS_API_COMPATIBLE'
have_macro! 'TOX_VERSION_IS_ABI_COMPATIBLE'

have_type! 'TOX_ERR_OPTIONS_NEW'
have_type! 'TOX_ERR_NEW'
have_type! 'TOX_ERR_BOOTSTRAP'
have_type! 'TOX_ERR_SET_INFO'
have_type! 'TOX_ERR_FRIEND_ADD'
have_type! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY'
have_type! 'TOX_ERR_FRIEND_QUERY'
have_type! 'TOX_ERR_FRIEND_SEND_MESSAGE'
have_type! 'TOX_SAVEDATA_TYPE'
have_type! 'TOX_MESSAGE_TYPE'
have_type! 'TOX_USER_STATUS'
have_type! 'tox_friend_request_cb'
have_type! 'tox_friend_message_cb'
have_type! 'tox_friend_name_cb'
have_type! 'tox_friend_status_message_cb'
have_type! 'tox_friend_status_cb'

have_struct_member! 'struct Tox_Options', 'savedata_type'
have_struct_member! 'struct Tox_Options', 'savedata_length'
have_struct_member! 'struct Tox_Options', 'savedata_data'

have_const! 'TOX_VERSION_MAJOR'
have_const! 'TOX_VERSION_MINOR'
have_const! 'TOX_VERSION_PATCH'
have_const! 'TOX_HASH_LENGTH'
have_const! 'TOX_SAVEDATA_TYPE_NONE'
have_const! 'TOX_SAVEDATA_TYPE_TOX_SAVE'
have_const! 'TOX_ERR_OPTIONS_NEW_OK'
have_const! 'TOX_ERR_OPTIONS_NEW_MALLOC'
have_const! 'TOX_ERR_NEW_OK'
have_const! 'TOX_ERR_NEW_NULL'
have_const! 'TOX_ERR_NEW_MALLOC'
have_const! 'TOX_ERR_NEW_PORT_ALLOC'
have_const! 'TOX_ERR_NEW_PROXY_BAD_TYPE'
have_const! 'TOX_ERR_NEW_PROXY_BAD_HOST'
have_const! 'TOX_ERR_NEW_PROXY_BAD_PORT'
have_const! 'TOX_ERR_NEW_PROXY_NOT_FOUND'
have_const! 'TOX_ERR_NEW_LOAD_ENCRYPTED'
have_const! 'TOX_ERR_NEW_LOAD_BAD_FORMAT'
have_const! 'TOX_ADDRESS_SIZE'
have_const! 'TOX_PUBLIC_KEY_SIZE'
have_const! 'TOX_ERR_BOOTSTRAP_OK'
have_const! 'TOX_ERR_BOOTSTRAP_NULL'
have_const! 'TOX_ERR_BOOTSTRAP_BAD_HOST'
have_const! 'TOX_ERR_BOOTSTRAP_BAD_PORT'
have_const! 'TOX_ERR_SET_INFO_OK'
have_const! 'TOX_ERR_SET_INFO_NULL'
have_const! 'TOX_ERR_SET_INFO_TOO_LONG'
have_const! 'TOX_ERR_FRIEND_ADD_OK'
have_const! 'TOX_ERR_FRIEND_ADD_NULL'
have_const! 'TOX_ERR_FRIEND_ADD_TOO_LONG'
have_const! 'TOX_ERR_FRIEND_ADD_NO_MESSAGE'
have_const! 'TOX_ERR_FRIEND_ADD_OWN_KEY'
have_const! 'TOX_ERR_FRIEND_ADD_ALREADY_SENT'
have_const! 'TOX_ERR_FRIEND_ADD_BAD_CHECKSUM'
have_const! 'TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM'
have_const! 'TOX_ERR_FRIEND_ADD_MALLOC'
have_const! 'TOX_MESSAGE_TYPE_NORMAL'
have_const! 'TOX_MESSAGE_TYPE_ACTION'
have_const! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK'
have_const! 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND'
have_const! 'TOX_ERR_FRIEND_QUERY_OK'
have_const! 'TOX_ERR_FRIEND_QUERY_NULL'
have_const! 'TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND'
have_const! 'TOX_USER_STATUS_NONE'
have_const! 'TOX_USER_STATUS_AWAY'
have_const! 'TOX_USER_STATUS_BUSY'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_OK'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_NULL'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG'
have_const! 'TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY'

have_func! 'tox_version_major'
have_func! 'tox_version_minor'
have_func! 'tox_version_patch'
have_func! 'tox_version_is_compatible'
have_func! 'tox_hash'
have_func! 'tox_new'
have_func! 'tox_options_default'
have_func! 'tox_options_get_ipv6_enabled'
have_func! 'tox_options_set_ipv6_enabled'
have_func! 'tox_options_get_udp_enabled'
have_func! 'tox_options_set_udp_enabled'
have_func! 'tox_options_get_local_discovery_enabled'
have_func! 'tox_options_set_local_discovery_enabled'
have_func! 'tox_options_get_proxy_type'
have_func! 'tox_options_set_proxy_type'
have_func! 'tox_options_get_proxy_host'
have_func! 'tox_options_set_proxy_host'
have_func! 'tox_options_get_proxy_port'
have_func! 'tox_options_set_proxy_port'
have_func! 'tox_options_get_start_port'
have_func! 'tox_options_set_start_port'
have_func! 'tox_options_get_end_port'
have_func! 'tox_options_set_end_port'
have_func! 'tox_options_get_tcp_port'
have_func! 'tox_options_set_tcp_port'
have_func! 'tox_get_savedata_size'
have_func! 'tox_get_savedata'
have_func! 'tox_self_get_address'
have_func! 'tox_self_get_nospam'
have_func! 'tox_self_set_nospam'
have_func! 'tox_self_get_public_key'
have_func! 'tox_self_get_udp_port'
have_func! 'tox_self_get_tcp_port'
have_func! 'tox_kill'
have_func! 'tox_bootstrap'
have_func! 'tox_iteration_interval'
have_func! 'tox_iterate'
have_func! 'tox_friend_add_norequest'
have_func! 'tox_friend_send_message'
have_func! 'tox_callback_friend_request'
have_func! 'tox_callback_friend_message'
have_func! 'tox_self_get_name_size'
have_func! 'tox_self_get_name'
have_func! 'tox_self_set_name'
have_func! 'tox_self_get_status_message_size'
have_func! 'tox_self_get_status_message'
have_func! 'tox_self_set_status_message'
have_func! 'tox_self_get_status'
have_func! 'tox_self_set_status'
have_func! 'tox_self_get_friend_list_size'
have_func! 'tox_self_get_friend_list'
have_func! 'tox_friend_exists'
have_func! 'tox_friend_get_public_key'
have_func! 'tox_friend_get_name_size'
have_func! 'tox_friend_get_name'
have_func! 'tox_friend_get_status_message'
have_func! 'tox_friend_get_status'
have_func! 'tox_callback_friend_name'
have_func! 'tox_callback_friend_status_message'
have_func! 'tox_callback_friend_status'

create_makefile 'tox/tox' or exit 1
