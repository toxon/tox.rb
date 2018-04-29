# frozen_string_literal: true

module Tox
  ##
  # Friend representation in Tox client.
  #
  class Friend
    using CoreExt

    attr_reader :client, :number

    def initialize(client, number)
      self.client = client
      self.number = number
    end

    def exist!
      raise NotFoundError, "friend #{number} not found" unless exist?
      self
    end

    alias exists! exist!

    def ==(other)
      return false unless self.class == other.class
      client == other.client &&
        number == other.number
    end

  private

    def client=(value)
      Client.ancestor_of! value
      @client = value
    end

    def number=(value)
      Integer.ancestor_of! value
      unless value >= 0
        raise 'Expected friend number to be greater than or equal to zero'
      end
      @number = value
    end

    class NotFoundError     < RuntimeError; end
    class NotConnectedError < RuntimeError; end
  end
end
