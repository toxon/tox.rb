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
        raise TypeError, "expected friend to be a #{Friend}"
      end
      @friend = value
    end

    def id=(value)
      unless value.is_a? Integer
        raise TypeError, "expected id to be an #{Integer}"
      end
      unless value >= 0
        raise ArgumentError, 'expected id to be greater than or equal to zero'
      end
      @id = value
    end
  end
end
