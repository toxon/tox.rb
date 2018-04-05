# frozen_string_literal: true

module Tox
  ##
  # Tox client.
  #
  class Client
    def initialize(options = Tox::Options.new)
      initialize_with options
      self.running = false
    end

    def bootstrap_official
      Status.new.udp_nodes.each do |node|
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

    def run
      unless mutex.try_lock
        raise AlreadyRunningError, "already running in #{thread}"
      end

      run_internal

      mutex.unlock
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

    attr_accessor :thread

    def mutex
      @mutex ||= Mutex.new
    end

    def running=(value)
      @running = !!value
    end

    def run_internal
      self.running = true
      self.thread = Thread.current
      run_loop
    ensure
      self.running = false
      self.thread = nil
    end

    class Error < RuntimeError; end
    class BadSavedataError < Error; end
    class AlreadyRunningError < Error; end
  end
end
