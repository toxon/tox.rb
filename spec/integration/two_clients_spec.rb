# frozen_string_literal: true

require 'network_helper'

RSpec.describe 'Two clients' do
  specify do
    options = Tox::Options.new
    options.local_discovery_enabled = false

    send_queue = Queue.new
    recv_queue = Queue.new

    send_client = Tox::Client.new options
    recv_client = Tox::Client.new options

    send_client.friend_add_norequest recv_client.public_key
    recv_client.friend_add_norequest send_client.public_key

    sleep 0.1 until send_client.friends.last.exist?
    sleep 0.1 until recv_client.friends.last.exist?

    FAKE_NODES.each do |node|
      expect(send_client.bootstrap(node)).to eq true
      expect(recv_client.bootstrap(node)).to eq true
    end

    send_friend = send_client.friends.last.exist!

    expect(send_friend).to be_instance_of Tox::Friend

    expect(send_friend.client).to be_instance_of Tox::Client
    expect(send_friend.client).to equal send_client

    expect(send_friend.number).to be_kind_of Integer
    expect(send_friend.number).to be >= 0

    # TODO: test friend public key

    send_client.on_iteration do
      send_queue.size.times do
        text = send_queue.pop true

        begin
          out_friend_message = send_friend.send_message text

          expect(out_friend_message).to be_instance_of Tox::OutFriendMessage

          expect(out_friend_message.client).to be_instance_of Tox::Client
          expect(out_friend_message.client).to equal send_client

          expect(out_friend_message.friend).to be_instance_of Tox::Friend
          expect(out_friend_message.friend).to eq send_friend

          expect(out_friend_message.id).to be_kind_of Integer
          expect(out_friend_message.id).to be >= 0
        rescue Tox::Friend::NotConnectedError
          send_queue << text
        end
      end
    end

    recv_client.on_friend_message do |_friend, text|
      recv_queue << text
    end

    send_thread = Thread.start do
      send_client.run
    end

    recv_thread = Thread.start do
      recv_client.run
    end

    sleep 0.1 until send_client.running?
    sleep 0.1 until recv_client.running?

    send_data = %w[foo bar car].freeze

    send_data.each do |text|
      send_queue << text
    end

    begin
      Timeout.timeout 60 do
        sleep 1 while recv_queue.size < send_data.size
      end

      recv_data = Set.new

      recv_queue.size.times do
        recv_data << recv_queue.pop(true)
      end

      expect(recv_data).to eq send_data.to_set
    ensure
      send_client.stop
      recv_client.stop

      send_thread.join
      recv_thread.join
    end
  end
end
