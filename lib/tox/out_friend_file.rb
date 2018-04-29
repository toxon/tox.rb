# frozen_string_literal: true

module Tox
  ##
  # Outgoing friend file representation in Tox client.
  #
  class OutFriendFile
    using CoreExt

    attr_reader :friend, :number

    def initialize(friend, number)
      self.friend = friend
      self.number = number
    end

    def client
      friend.client
    end

    def ==(other)
      self.class == other.class &&
        friend == other.friend &&
        number == other.number
    end

  private

    def friend=(value)
      Friend.ancestor_of! value
      @friend = value
    end

    def number=(value)
      Integer.ancestor_of! value
      unless value >= 0
        raise 'Expected file number to be greater than or equal to zero'
      end
      @number = value
    end

    class NameTooLongError < RuntimeError; end
    class TooManyError     < RuntimeError; end
  end
end
