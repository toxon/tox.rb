# frozen_string_literal: true

module Tox
  ##
  # Tox client.
  #
  class Client
    def initialize(options = Tox::Options.new)
      initialize_with options
    end

    def bootstrap_official
      Status.new.nodes.each do |node|
        bootstrap node
      end
    end

    def running?
      @running
    end

    def stop
      return false unless running?
      self.running = false
      true
    end

    def on_friend_request(&block)
      @on_friend_request = block
    end

    def on_friend_message(&block)
      @on_friend_message = block
    end

  private

    def running=(value)
      @running = !!value
    end
  end
end
