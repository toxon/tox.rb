# frozen_string_literal: true

require 'network_helper'

RSpec.describe 'Basics' do
  let :options do
    Tox::Options.new.tap do |options|
      options.local_discovery_enabled = false
    end
  end

  specify do
    client_1 = Tox::Client.new options
    client_2 = Tox::Client.new options

    client_1.friend_add_norequest client_2.public_key
    client_2.friend_add_norequest client_1.public_key

    sleep 0.1 until client_1.friends.last.exist?
    sleep 0.1 until client_2.friends.last.exist?

    expect(client_1.connection_status).to eq Tox::ConnectionStatus::NONE
    expect(client_2.connection_status).to eq Tox::ConnectionStatus::NONE

    FAKE_NODES.each do |node|
      expect(
        client_1.bootstrap(node.resolv_ipv4, node.port, node.public_key),
      ).to eq true

      expect(
        client_2.bootstrap(node.resolv_ipv4, node.port, node.public_key),
      ).to eq true
    end

    FAKE_TCP_RELAYS.each do |tcp_relay|
      tcp_relay[:ports].each do |port|
        expect(
          client_1.add_tcp_relay('127.0.0.1', port, tcp_relay[:public_key]),
        ).to eq true

        expect(
          client_2.add_tcp_relay('127.0.0.1', port, tcp_relay[:public_key]),
        ).to eq true
      end
    end

    client_1_friend_2 = client_1.friends.last.exist!

    expect(client_1_friend_2).to be_instance_of Tox::Friend

    expect(client_1_friend_2.client).to be_instance_of Tox::Client
    expect(client_1_friend_2.client).to equal client_1

    expect(client_1_friend_2.number).to be_kind_of Integer
    expect(client_1_friend_2.number).to be >= 0

    # TODO: test friend public key

    client_1_send_queue = Queue.new
    client_2_recv_queue = Queue.new

    client_1.on_iteration do
      client_1_send_queue.size.times do
        text = client_1_send_queue.pop true

        begin
          out_friend_message = client_1_friend_2.send_message text

          expect(out_friend_message).to be_instance_of Tox::OutFriendMessage

          expect(out_friend_message.client).to be_instance_of Tox::Client
          expect(out_friend_message.client).to equal client_1

          expect(out_friend_message.friend).to be_instance_of Tox::Friend
          expect(out_friend_message.friend).to eq client_1_friend_2

          expect(out_friend_message.id).to be_kind_of Integer
          expect(out_friend_message.id).to be >= 0
        rescue Tox::Friend::NotConnectedError
          client_1_send_queue << text
        end
      end
    end

    client_2.on_friend_message do |_friend, text|
      client_2_recv_queue << text
    end

    client_1_thread = Thread.start do
      client_1.run
    end

    client_2_thread = Thread.start do
      client_2.run
    end

    sleep 0.1 until client_1.running?
    sleep 0.1 until client_2.running?

    send_data = %w[foo bar car].freeze

    send_data.each do |text|
      client_1_send_queue << text
    end

    begin
      Timeout.timeout 60 do
        sleep 1 while client_2_recv_queue.size < send_data.size
      end

      recv_data = Set.new

      client_2_recv_queue.size.times do
        recv_data << client_2_recv_queue.pop(true)
      end

      expect(recv_data).to eq send_data.to_set
    ensure
      client_1.stop
      client_2.stop

      client_1_thread.join
      client_2_thread.join
    end
  end
end
