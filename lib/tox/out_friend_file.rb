# frozen_string_literal: true

module Tox
  ##
  # Outgoing friend file representation in Tox client.
  #
  class OutFriendFile
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
      unless value.is_a? Friend
        raise TypeError, "Expected #{Friend}, got #{value.class}"
      end
      @friend = value
    end

    def number=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless value >= 0
        raise 'Expected file number to be greater than or equal to zero'
      end
      @number = value
    end

    class NameTooLongError < RuntimeError; end
    class TooManyError     < RuntimeError; end
  end
end
