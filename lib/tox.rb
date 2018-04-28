# frozen_string_literal: true

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
require 'tox/out_friend_message'
require 'tox/friend'
require 'tox/audio_video'
require 'tox/out_friend_file'
require 'tox/in_friend_file'
require 'tox/friend_call_state'
require 'tox/friend_call_request'
require 'tox/friend_call'

require 'tox/proxies/base'
require 'tox/proxies/http'
require 'tox/proxies/socks5'

# Enumerations
require 'tox/user_status'
require 'tox/proxy_type'
require 'tox/connection_status'
require 'tox/file_kind'
require 'tox/file_control'

# Binary string primitives
require 'tox/binary'
require 'tox/public_key'
require 'tox/nospam'
require 'tox/address_checksum'
require 'tox/address'

# Media data primitives
require 'tox/audio_frame'
require 'tox/video_frame'

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
  # Exception of this type is raised when packet send queue is full.
  #
  class SendQueueError < RuntimeError; end

  ##
  # Exception of this type is raised when Tox function failed with unknown
  # error code or returned false success status. It can indicate minor version
  # upgrade of libtoxcore. Specific handling is not needed for the time beeing.
  #
  class UnknownError < RuntimeError; end
end

# C extension
require 'tox/tox'
