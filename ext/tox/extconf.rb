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

def have_struct_member!(header, *args)
  exit 1 unless have_struct_member(*args, header)
end

def have_func!(header, *args)
  exit 1 unless have_func(*args, header)
end

def have_macro!(header, *args)
  exit 1 unless have_macro(*args, header)
end

def have_type!(header, *args)
  exit 1 unless have_type(*args, header)
end

def have_const!(header, *args)
  exit 1 unless have_const(*args, header)
end

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

have_library! 'toxcore'
have_library! 'toxav'

have_header! 'ruby.h'
have_header! 'time.h'
have_header! 'tox/tox.h'
have_header! 'tox/toxav.h'

have_struct_member! nil, 'struct timespec', 'tv_sec'
have_struct_member! nil, 'struct timespec', 'tv_nsec'

have_func! nil, 'free'
have_func! nil, 'memset'
have_func! nil, 'sprintf'
have_func! nil, 'nanosleep'

have_macro! 'tox/tox.h', 'TOX_VERSION_IS_API_COMPATIBLE'
have_macro! 'tox/tox.h', 'TOX_VERSION_IS_ABI_COMPATIBLE'

have_type! 'tox/tox.h', 'TOX_ERR_OPTIONS_NEW'
have_type! 'tox/tox.h', 'TOX_ERR_NEW'
have_type! 'tox/tox.h', 'TOX_ERR_BOOTSTRAP'
have_type! 'tox/tox.h', 'TOX_ERR_SET_INFO'
have_type! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD'
have_type! 'tox/tox.h', 'TOX_ERR_FRIEND_GET_PUBLIC_KEY'
have_type! 'tox/tox.h', 'TOX_ERR_FRIEND_QUERY'
have_type! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE'
have_type! 'tox/tox.h', 'TOX_ERR_FILE_SEND'
have_type! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK'
have_type! 'tox/tox.h', 'TOX_SAVEDATA_TYPE'
have_type! 'tox/tox.h', 'TOX_MESSAGE_TYPE'
have_type! 'tox/tox.h', 'TOX_USER_STATUS'
have_type! 'tox/tox.h', 'TOX_CONNECTION'
have_type! 'tox/tox.h', 'enum TOX_FILE_KIND'
have_type! 'tox/tox.h', 'enum TOX_FILE_CONTROL'
have_type! 'tox/tox.h', 'tox_friend_request_cb'
have_type! 'tox/tox.h', 'tox_friend_message_cb'
have_type! 'tox/tox.h', 'tox_friend_name_cb'
have_type! 'tox/tox.h', 'tox_friend_status_message_cb'
have_type! 'tox/tox.h', 'tox_friend_status_cb'
have_type! 'tox/tox.h', 'tox_file_chunk_request_cb'
have_type! 'tox/tox.h', 'tox_file_recv_cb'
have_type! 'tox/tox.h', 'tox_file_recv_chunk_cb'

have_type! 'tox/toxav.h', 'TOXAV_ERR_NEW'

have_struct_member! 'tox/tox.h', 'struct Tox_Options', 'savedata_type'
have_struct_member! 'tox/tox.h', 'struct Tox_Options', 'savedata_length'
have_struct_member! 'tox/tox.h', 'struct Tox_Options', 'savedata_data'

have_const! 'tox/tox.h', 'TOX_VERSION_MAJOR'
have_const! 'tox/tox.h', 'TOX_VERSION_MINOR'
have_const! 'tox/tox.h', 'TOX_VERSION_PATCH'
have_const! 'tox/tox.h', 'TOX_HASH_LENGTH'
have_const! 'tox/tox.h', 'TOX_SAVEDATA_TYPE_NONE'
have_const! 'tox/tox.h', 'TOX_SAVEDATA_TYPE_TOX_SAVE'
have_const! 'tox/tox.h', 'TOX_ERR_OPTIONS_NEW_OK'
have_const! 'tox/tox.h', 'TOX_ERR_OPTIONS_NEW_MALLOC'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_OK'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_MALLOC'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_PORT_ALLOC'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_PROXY_BAD_TYPE'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_PROXY_BAD_HOST'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_PROXY_BAD_PORT'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_PROXY_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_LOAD_ENCRYPTED'
have_const! 'tox/tox.h', 'TOX_ERR_NEW_LOAD_BAD_FORMAT'
have_const! 'tox/tox.h', 'TOX_ADDRESS_SIZE'
have_const! 'tox/tox.h', 'TOX_PUBLIC_KEY_SIZE'
have_const! 'tox/tox.h', 'TOX_ERR_BOOTSTRAP_OK'
have_const! 'tox/tox.h', 'TOX_ERR_BOOTSTRAP_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_BOOTSTRAP_BAD_HOST'
have_const! 'tox/tox.h', 'TOX_ERR_BOOTSTRAP_BAD_PORT'
have_const! 'tox/tox.h', 'TOX_ERR_SET_INFO_OK'
have_const! 'tox/tox.h', 'TOX_ERR_SET_INFO_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_SET_INFO_TOO_LONG'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_TOO_LONG'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_NO_MESSAGE'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_OWN_KEY'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_ALREADY_SENT'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_BAD_CHECKSUM'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_ADD_MALLOC'
have_const! 'tox/tox.h', 'TOX_MESSAGE_TYPE_NORMAL'
have_const! 'tox/tox.h', 'TOX_MESSAGE_TYPE_ACTION'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_GET_PUBLIC_KEY_FRIEND_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_QUERY_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_QUERY_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_QUERY_FRIEND_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_USER_STATUS_NONE'
have_const! 'tox/tox.h', 'TOX_USER_STATUS_AWAY'
have_const! 'tox/tox.h', 'TOX_USER_STATUS_BUSY'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_FRIEND_NOT_CONNECTED'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_SENDQ'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_TOO_LONG'
have_const! 'tox/tox.h', 'TOX_ERR_FRIEND_SEND_MESSAGE_EMPTY'
have_const! 'tox/tox.h', 'TOX_CONNECTION_NONE'
have_const! 'tox/tox.h', 'TOX_CONNECTION_TCP'
have_const! 'tox/tox.h', 'TOX_CONNECTION_UDP'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_FRIEND_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_FRIEND_NOT_CONNECTED'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_NAME_TOO_LONG'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_TOO_MANY'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_OK'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_NULL'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_FRIEND_NOT_CONNECTED'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_NOT_FOUND'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_NOT_TRANSFERRING'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_INVALID_LENGTH'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_SENDQ'
have_const! 'tox/tox.h', 'TOX_ERR_FILE_SEND_CHUNK_WRONG_POSITION'
have_const! 'tox/tox.h', 'TOX_FILE_KIND_DATA'
have_const! 'tox/tox.h', 'TOX_FILE_KIND_AVATAR'
have_const! 'tox/tox.h', 'TOX_FILE_CONTROL_RESUME'
have_const! 'tox/tox.h', 'TOX_FILE_CONTROL_PAUSE'
have_const! 'tox/tox.h', 'TOX_FILE_CONTROL_CANCEL'

have_const! 'tox/toxav.h', 'TOXAV_ERR_NEW_OK'
have_const! 'tox/toxav.h', 'TOXAV_ERR_NEW_NULL'
have_const! 'tox/toxav.h', 'TOXAV_ERR_NEW_MALLOC'
have_const! 'tox/toxav.h', 'TOXAV_ERR_NEW_MULTIPLE'

have_func! 'tox/tox.h', 'tox_version_major'
have_func! 'tox/tox.h', 'tox_version_minor'
have_func! 'tox/tox.h', 'tox_version_patch'
have_func! 'tox/tox.h', 'tox_version_is_compatible'
have_func! 'tox/tox.h', 'tox_hash'
have_func! 'tox/tox.h', 'tox_new'
have_func! 'tox/tox.h', 'tox_options_default'
have_func! 'tox/tox.h', 'tox_options_get_ipv6_enabled'
have_func! 'tox/tox.h', 'tox_options_set_ipv6_enabled'
have_func! 'tox/tox.h', 'tox_options_get_udp_enabled'
have_func! 'tox/tox.h', 'tox_options_set_udp_enabled'
have_func! 'tox/tox.h', 'tox_options_get_local_discovery_enabled'
have_func! 'tox/tox.h', 'tox_options_set_local_discovery_enabled'
have_func! 'tox/tox.h', 'tox_options_get_proxy_type'
have_func! 'tox/tox.h', 'tox_options_set_proxy_type'
have_func! 'tox/tox.h', 'tox_options_get_proxy_host'
have_func! 'tox/tox.h', 'tox_options_set_proxy_host'
have_func! 'tox/tox.h', 'tox_options_get_proxy_port'
have_func! 'tox/tox.h', 'tox_options_set_proxy_port'
have_func! 'tox/tox.h', 'tox_options_get_start_port'
have_func! 'tox/tox.h', 'tox_options_set_start_port'
have_func! 'tox/tox.h', 'tox_options_get_end_port'
have_func! 'tox/tox.h', 'tox_options_set_end_port'
have_func! 'tox/tox.h', 'tox_options_get_tcp_port'
have_func! 'tox/tox.h', 'tox_options_set_tcp_port'
have_func! 'tox/tox.h', 'tox_get_savedata_size'
have_func! 'tox/tox.h', 'tox_get_savedata'
have_func! 'tox/tox.h', 'tox_self_get_address'
have_func! 'tox/tox.h', 'tox_self_get_nospam'
have_func! 'tox/tox.h', 'tox_self_set_nospam'
have_func! 'tox/tox.h', 'tox_self_get_public_key'
have_func! 'tox/tox.h', 'tox_self_get_udp_port'
have_func! 'tox/tox.h', 'tox_self_get_tcp_port'
have_func! 'tox/tox.h', 'tox_kill'
have_func! 'tox/tox.h', 'tox_bootstrap'
have_func! 'tox/tox.h', 'tox_add_tcp_relay'
have_func! 'tox/tox.h', 'tox_iteration_interval'
have_func! 'tox/tox.h', 'tox_iterate'
have_func! 'tox/tox.h', 'tox_friend_add_norequest'
have_func! 'tox/tox.h', 'tox_friend_send_message'
have_func! 'tox/tox.h', 'tox_callback_friend_request'
have_func! 'tox/tox.h', 'tox_callback_friend_message'
have_func! 'tox/tox.h', 'tox_self_get_name_size'
have_func! 'tox/tox.h', 'tox_self_get_name'
have_func! 'tox/tox.h', 'tox_self_set_name'
have_func! 'tox/tox.h', 'tox_self_get_status_message_size'
have_func! 'tox/tox.h', 'tox_self_get_status_message'
have_func! 'tox/tox.h', 'tox_self_set_status_message'
have_func! 'tox/tox.h', 'tox_self_get_status'
have_func! 'tox/tox.h', 'tox_self_set_status'
have_func! 'tox/tox.h', 'tox_self_get_friend_list_size'
have_func! 'tox/tox.h', 'tox_self_get_friend_list'
have_func! 'tox/tox.h', 'tox_friend_exists'
have_func! 'tox/tox.h', 'tox_friend_get_public_key'
have_func! 'tox/tox.h', 'tox_friend_get_name_size'
have_func! 'tox/tox.h', 'tox_friend_get_name'
have_func! 'tox/tox.h', 'tox_friend_get_status_message'
have_func! 'tox/tox.h', 'tox_friend_get_status'
have_func! 'tox/tox.h', 'tox_callback_friend_name'
have_func! 'tox/tox.h', 'tox_callback_friend_status_message'
have_func! 'tox/tox.h', 'tox_callback_friend_status'
have_func! 'tox/tox.h', 'tox_file_send'
have_func! 'tox/tox.h', 'tox_file_send_chunk'
have_func! 'tox/tox.h', 'tox_callback_file_chunk_request'
have_func! 'tox/tox.h', 'tox_callback_file_recv'
have_func! 'tox/tox.h', 'tox_callback_file_recv_chunk'

have_func! 'tox/toxav.h', 'toxav_new'
have_func! 'tox/toxav.h', 'toxav_kill'

create_makefile 'tox/tox' or exit 1
