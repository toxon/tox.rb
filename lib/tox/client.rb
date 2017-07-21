# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
