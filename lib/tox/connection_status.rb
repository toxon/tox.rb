# frozen_string_literal: true

module Tox
  ##
  # Protocols that can be used to connect to the network or friends.
  #
  module ConnectionStatus
    # There is no connection. This instance, or the friend the state change
    # is about, is now offline.
    NONE = :none

    # A TCP connection has been established. For the own instance, this means
    # it is connected through a TCP relay, only. For a friend, this means that
    # the connection to that particular friend goes through a TCP relay.
    TCP = :tcp

    # A UDP connection has been established. For the own instance, this means
    # it is able to send UDP packets to DHT nodes, but may still be connected
    # to a TCP relay. For a friend, this means that the connection
    # to that particular friend was built using direct UDP packets.
    UDP = :udp
  end
end
