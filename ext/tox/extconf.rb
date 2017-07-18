#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

NAME = 'tox'

LIBTOXCORE = 'toxcore'

have_header 'tox/tox.h' and

have_library LIBTOXCORE, 'tox_new' and
have_library LIBTOXCORE, 'tox_options_default' and

create_makefile "#{NAME}/#{NAME}" or exit 1
