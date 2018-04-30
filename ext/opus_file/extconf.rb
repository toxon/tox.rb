#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

ENV['PKG_CONFIG_PATH'] =
  File.expand_path(
    File.join('..', '..', 'vendor', 'lib', 'pkgconfig'),
    __dir__,
  ).freeze

def cflags(*args)
  args.each do |str|
    $CFLAGS += " #{str.shellescape} "
  end
end

def pkg_config!(*args)
  exit 1 unless pkg_config(*args)
end

def have_library!(*args)
  exit 1 unless have_library(*args)
end

def have_header!(*args)
  exit 1 unless have_header(*args)
end

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

pkg_config! 'opusfile'

have_library! 'opusfile'

have_header! 'opus/opusfile.h'

create_makefile 'opus_file' or exit 1
