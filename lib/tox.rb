# frozen_string_literal: true

require 'thread'
require 'uri'
require 'net/http'
require 'json'
require 'resolv'

require 'tox/version'
require 'tox/options'
require 'tox/client'
require 'tox/status'
require 'tox/node'
require 'tox/out_message'
require 'tox/friend'
require 'tox/friend/out_message'

# Enumerations
require 'tox/user_status'
require 'tox/proxy_type'

# Primitives
require 'tox/binary'
require 'tox/public_key'
require 'tox/nospam'
require 'tox/address_checksum'
require 'tox/address'

##
# Ruby interface for libtoxcore. It can be used to create Tox chat client or
# bot. The interface is object-oriented instead of C-style (raises exceptions
# instead of returning error codes, uses classes to represent primitives, etc.)
#
module Tox
  ##
  # Exception of this type is raised when Tox function failed with error code
  # represented in Tox headers with a constant which name ends with "_NULL".
  # This happens when one of the arguments to the function was NULL when it was
  # not expected. It can indicate that usage of the Tox function is invalid,
  # so if you got exception of this type please create an issue:
  # https://github.com/toxon/tox.rb/issues
  # Please describe the situation, version of libtoxcore, version of the gem.
  #
  class NullError < RuntimeError; end

  ##
  # Exception of this type is raised when Tox function failed with unknown
  # error code or returned false success status. It can indicate minor version
  # upgrade of libtoxcore. Specific handling is not needed for the time beeing.
  #
  class UnknownError < RuntimeError; end
end

# C extension
require 'tox/tox'
