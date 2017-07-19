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
      Status::Official.new.nodes.each do |node|
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
      raise AlreadyRunningError, "already running in #{thread}" unless mutex.try_lock

      begin
        self.running = true
        self.thread = Thread.current
        run_loop
      ensure
        self.running = false
        self.thread = nil
      end

      mutex.unlock
    end

    def on_friend_request(&block)
      @on_friend_request = block
    end

    def on_friend_message(&block)
      @on_friend_message = block
    end

  private

    attr_accessor :thread

    def mutex
      @mutex ||= Mutex.new
    end

    def running=(value)
      @running = !!value
    end

    class Error < RuntimeError; end
    class BadSavedataError < Error; end
    class AlreadyRunningError < Error; end
  end
end
