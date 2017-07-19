# frozen_string_literal: true

require 'thread'
require 'uri'
require 'net/http'
require 'json'
require 'resolv'

require 'tox/version'
require 'tox/status'
require 'tox/node'
require 'tox/tox'
require 'tox/client'

##
# Ruby interface for libtoxcore. It can be used to create Tox chat client or bot.
# It provides object-oriented interface instead of C-style (raises exceptions
# instead of returning error codes, uses classes to represent primitives, etc.)
#
module Tox
end
