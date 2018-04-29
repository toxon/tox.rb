# frozen_string_literal: true

module Tox
  ##
  # Outgoing friend message representation in Tox client.
  #
  class OutFriendMessage
    using CoreExt

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
      Friend.ancestor_of! value
      @friend = value
    end

    def id=(value)
      Integer.ancestor_of! value
      unless value >= 0
        raise 'Expected message ID to be greater than or equal to zero'
      end
      @id = value
    end
  end
end
