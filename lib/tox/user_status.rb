# frozen_string_literal: true

module Tox
  ##
  # Represents the possible statuses a client can have.
  #
  module UserStatus
    # User is online and available.
    NONE = :none

    # User is away. Clients can set this e.g. after a user defined
    # inactivity time.
    AWAY = :away

    # User is busy. Signals to other clients that this client does not
    # currently wish to communicate.
    BUSY = :busy
  end
end
