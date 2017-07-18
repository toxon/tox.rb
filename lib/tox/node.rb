# frozen_string_literal: true

module Tox
  ##
  # Tox node credentials.
  #
  class Node
    PORT_RANGE = 0..65_535

    attr_reader :public_key, :port, :ipv4

    def initialize(public_key, port, ipv4_host)
      self.public_key = public_key
      self.port       = port
      self.ipv4       = Resolv.getaddress ipv4_host
    end

  private

    def public_key=(value)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String
      @public_key = value.frozen? ? value : value.dup.freeze
    end

    def port=(value)
      raise TypeError,     "expected value to be an #{Integer}"       unless value.is_a? Integer
      raise ArgumentError, 'expected value to be between 0 and 65535' unless PORT_RANGE.cover? value
      @port = value
    end

    def ipv4=(value)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String
      @ipv4 = value.frozen? ? value : value.dup.freeze
    end
  end
end
