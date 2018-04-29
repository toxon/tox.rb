# frozen_string_literal: true

module Tox
  ##
  # Abstract module for outgoing message representation in Tox client.
  #
  module OutMessage
    using CoreExt

    abstract_method :initialize
    abstract_method :client

    def ==(other)
      self.class == other.class &&
        friend == other.friend &&
        id == other.id
    end

    class TooLongError < RuntimeError;  end
    class EmptyError   < RuntimeError;  end
  end
end
