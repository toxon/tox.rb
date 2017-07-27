# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'thread'
require 'uri'
require 'net/http'
require 'json'
require 'resolv'

require 'tox/version'
require 'tox/user_status'
require 'tox/options'
require 'tox/client'
require 'tox/status'
require 'tox/node'
require 'tox/friend'
require 'tox/friend/out_message'

# Primitives
require 'tox/binary'
require 'tox/public_key'
require 'tox/nospam'
require 'tox/address'

# C extension
require 'tox/tox'

##
# Ruby interface for libtoxcore. It can be used to create Tox chat client or bot.
# The interface is object-oriented instead of C-style (raises exceptions
# instead of returning error codes, uses classes to represent primitives, etc.)
#
module Tox
end
