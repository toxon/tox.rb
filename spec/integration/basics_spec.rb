# frozen_string_literal: true

require 'network_helper'

require 'celluloid'

class Wrapper
  include Celluloid

  def initialize(client)
    @client = client
    @client.on_friend_message(&method(:on_friend_message))
  end

  def connection_status
    @client.connection_status
  end

  def public_key
    @client.public_key
  end

  def friend_messages
    @friend_messages ||= []
  end

  def run
    loop do
      sleep @client.iteration_interval
      @client.iterate
    end
  end

  def friend_add_norequest(public_key)
    @client.friend_add_norequest public_key
  end

  def send_friend_message(friend_number, text)
    @client.friend(friend_number).send_message text
  rescue Tox::Friend::NotConnectedError
    sleep 0.01
    retry
  end

  def bootstrap(address, port, public_key)
    @client.bootstrap address, port, public_key
  end

  def add_tcp_relay(address, port, public_key)
    @client.add_tcp_relay address, port, public_key
  end

private

  def on_friend_message(_friend, text)
    @friend_messages << text
  end
end

# rubocop:disable Style/VariableNumber

RSpec.describe 'Basics' do
  specify do
    options_1 = Tox::Options.new.tap do |options|
      options.local_discovery_enabled = false
    end

    options_2 = Tox::Options.new.tap do |options|
      options.local_discovery_enabled = false
    end

    client_1 = Tox::Client.new options_1
    client_2 = Tox::Client.new options_2

    client_1_wrapper = Wrapper.new client_1
    client_2_wrapper = Wrapper.new client_2

    client_1_friend_2 =
      client_1_wrapper.friend_add_norequest client_2_wrapper.public_key

    _client_2_friend_1 =
      client_2_wrapper.friend_add_norequest client_1_wrapper.public_key

    FAKE_NODES.each do |node|
      client_1_wrapper.bootstrap node.resolv_ipv4, node.port, node.public_key
      client_2_wrapper.bootstrap node.resolv_ipv4, node.port, node.public_key
    end

    FAKE_TCP_RELAYS.each do |tcp_relay|
      tcp_relay[:ports].each do |port|
        client_1_wrapper.add_tcp_relay '127.0.0.1', port, tcp_relay[:public_key]
        client_2_wrapper.add_tcp_relay '127.0.0.1', port, tcp_relay[:public_key]
      end
    end

    client_1_wrapper.async.run
    client_2_wrapper.async.run

    send_data = %w[foo bar car].freeze

    send_data.each do |text|
      client_1_wrapper.send_friend_message client_1_friend_2.number, text
    end

    Timeout.timeout 60 do
      sleep 1 while client_2_wrapper.friend_messages.size < send_data.size
    end

    expect(client_2_wrapper.friend_messages.to_set).to eq send_data.to_set
  end
end
