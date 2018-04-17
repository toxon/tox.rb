# frozen_string_literal: true

module Tox
  ##
  # Tox client.
  #
  class Client
    def initialize(options = Tox::Options.new)
      @on_friend_request = nil
      @on_friend_message = nil
      @on_friend_name_change = nil
      @on_friend_status_message_change = nil
      @on_friend_status_change = nil
      @on_file_chunk_request = nil
      @on_file_recv_request = nil
      @on_file_recv_chunk = nil
      @on_file_recv_control = nil

      initialize_with options
    end

    def bootstrap_official
      Status.new.udp_nodes.each do |node|
        bootstrap node.resolv_ipv4, node.port, node.public_key
      end
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

    def on_file_chunk_request(&block)
      @on_file_chunk_request = block
    end

    def on_file_recv_request(&block)
      @on_file_recv_request = block
    end

    def on_file_recv_chunk(&block)
      @on_file_recv_chunk = block
    end

    def on_file_recv_control(&block)
      @on_file_recv_control = block
    end

    class Error < RuntimeError; end
    class BadSavedataError < Error; end
  end
end
