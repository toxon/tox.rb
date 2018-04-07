# frozen_string_literal: true

module Tox
  ##
  # Friend representation in Tox client.
  #
  class Friend
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
      self.client == other.client &&
        self.number == other.number
    end

  private

    def client=(value)
      unless value.is_a? Client
        raise TypeError, "expected client to be a #{Client}"
      end
      @client = value
    end

    def number=(value)
      unless value.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{value.class}"
      end
      unless value >= 0
        raise 'Expected friend number to be greater than or equal to zero'
      end
      @number = value
    end

    class NotFoundError     < RuntimeError; end
    class NotConnectedError < RuntimeError; end
  end
end
