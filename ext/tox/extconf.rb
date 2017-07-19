#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

LIBTOXCORE = 'toxcore'

$CFLAGS += ' -std=c99'

have_header 'ruby.h' and
have_header 'tox/tox.h' and

have_func 'free' and
have_func 'memset' and
have_func 'sprintf' and

have_library LIBTOXCORE, 'tox_version_is_compatible' and
have_library LIBTOXCORE, 'tox_new' and
have_library LIBTOXCORE, 'tox_options_default' and
have_library LIBTOXCORE, 'tox_get_savedata_size' and
have_library LIBTOXCORE, 'tox_get_savedata' and
have_library LIBTOXCORE, 'tox_self_get_address' and
have_library LIBTOXCORE, 'tox_kill' and
have_library LIBTOXCORE, 'tox_bootstrap' and

create_makefile 'tox/tox' or exit 1
