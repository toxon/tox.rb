#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

$CFLAGS += ' -std=c99'

have_library 'toxcore' and

have_header 'ruby.h' and
have_header 'tox/tox.h' and

have_func 'free' and
have_func 'memset' and
have_func 'sprintf' and

have_macro 'TOX_VERSION_IS_API_COMPATIBLE', 'tox/tox.h' and
have_macro 'TOX_VERSION_IS_ABI_COMPATIBLE', 'tox/tox.h' and

have_const 'TOX_SAVEDATA_TYPE_TOX_SAVE', 'tox/tox.h' and
have_const 'TOX_ERR_NEW_OK',             'tox/tox.h' and
have_const 'TOX_ADDRESS_SIZE',           'tox/tox.h' and
have_const 'TOX_PUBLIC_KEY_SIZE',        'tox/tox.h' and
have_const 'TOX_ERR_BOOTSTRAP_OK',       'tox/tox.h' and

have_func 'tox_version_is_compatible', 'tox/tox.h' and
have_func 'tox_new',                   'tox/tox.h' and
have_func 'tox_options_default',       'tox/tox.h' and
have_func 'tox_get_savedata_size',     'tox/tox.h' and
have_func 'tox_get_savedata',          'tox/tox.h' and
have_func 'tox_self_get_address',      'tox/tox.h' and
have_func 'tox_kill',                  'tox/tox.h' and
have_func 'tox_bootstrap',             'tox/tox.h' and

create_makefile 'tox/tox' or exit 1
