# frozen_string_literal: true

module Tox
  ##
  # Outgoing friend message representation in Tox client.
  #
  class OutFriendMessage
    include OutMessage

    attr_reader :friend, :id

    def initialize(friend, id)
      self.friend = friend
      self.id = id
    end

    def client
      friend.client
    end

  private

    def friend=(value)
      unless value.is_a? Friend
        raise TypeError, "Expected #{Friend}, got #{value.class}"
      end
      @friend = value
    end

    def id=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless value >= 0
        raise 'Expected message ID to be greater than or equal to zero'
      end
      @id = value
    end
  end
end
