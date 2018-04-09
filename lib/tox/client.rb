# frozen_string_literal: true

module Tox
  ##
  # Tox client.
  #
  class Client
    def initialize(options = Tox::Options.new)
      @on_iteration = nil
      @on_friend_request = nil
      @on_friend_message = nil
      @on_friend_name_change = nil
      @on_friend_status_message_change = nil
      @on_friend_status_change = nil

      initialize_with options
      self.running = false
    end

    def bootstrap_official
      Status.new.udp_nodes.each do |node|
        bootstrap node.resolv_ipv4, node.port, node.public_key
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

    def run
      self.running = true
      while running?
        sleep iteration_interval
        iterate
        @on_iteration&.call
      end
    ensure
      self.running = false
    end

    def friends
      friend_numbers.map do |friend_number|
        friend friend_number
      end
    end

    def friend(number)
      Friend.new self, number
    end

    def friend!(number)
      Friend.new(self, number).exist!
    end

    def on_iteration(&block)
      @on_iteration = block
    end

    def on_friend_request(&block)
      @on_friend_request = block
    end

    def on_friend_message(&block)
      @on_friend_message = block
    end

    def on_friend_name_change(&block)
      @on_friend_name_change = block
    end

    def on_friend_status_message_change(&block)
      @on_friend_status_message_change = block
    end

    def on_friend_status_change(&block)
      @on_friend_status_change = block
    end

  private

    def running=(value)
      @running = !!value
    end

    class Error < RuntimeError; end
    class BadSavedataError < Error; end
    class AlreadyRunningError < Error; end
  end
end
