#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

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

pkg_config! 'vorbisfile'

have_library! 'vorbisfile'

have_header! 'vorbis/vorbisfile.h'

create_makefile 'vorbis_file' or exit 1
