#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

LIBTOXCORE = 'toxcore'

have_header 'ruby.h' and
have_header 'tox/tox.h' and

have_func 'free' and
have_func 'memset' and

have_library LIBTOXCORE, 'tox_new' and
have_library LIBTOXCORE, 'tox_options_default' and
have_library LIBTOXCORE, 'tox_get_savedata_size' and
have_library LIBTOXCORE, 'tox_get_savedata' and
have_library LIBTOXCORE, 'tox_self_get_address' and
have_library LIBTOXCORE, 'tox_kill' and

create_makefile 'tox/tox' or exit 1
