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

  private

    def client=(value)
      raise TypeError, "expected client to be a #{Client}" unless value.is_a? Client
      @client = value
    end

    def number=(value)
      raise TypeError,     "expected number to be a #{Integer}"                  unless value.is_a? Integer
      raise ArgumentError, 'expected number to be greater than or equal to zero' unless value >= 0
      @number = value
    end
  end
end
