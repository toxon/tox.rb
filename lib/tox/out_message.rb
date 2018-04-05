# frozen_string_literal: true

module Tox
  ##
  # Abstract module for outgoing message representation in Tox client.
  #
  module OutMessage
    def initialize(*)
      raise NotImplementedError, "#{self.class}#initialize"
    end

    def client
      raise NotImplementedError, "#{self.class}#client"
    end

    class SendQueueAllocError < NoMemoryError; end
    class TooLongError        < RuntimeError;  end
    class EmptyError          < RuntimeError;  end
  end
end
