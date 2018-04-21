#!/usr/bin/env ruby
# frozen_string_literal: true

require 'mkmf'

def cflags(str)
  $CFLAGS += " #{str} "
end

cflags '-std=c11'
cflags '-Wall'
cflags '-Wextra'
cflags '-Wno-declaration-after-statement'

create_makefile 'gst-plugins-tox'
