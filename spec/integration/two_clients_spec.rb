# frozen_string_literal: true

require 'network_helper'

require 'celluloid'

class Wrapper
  include Celluloid

  def initialize(options)
    @client = Tox::Client.new options
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

  def send_friend_message(text)
    @client.friend(@client.friend_numbers.last).send_message text
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
    friend_messages << text
  end
end

# rubocop:disable Style/VariableNumber

RSpec.describe 'Two clients' do
  let(:messages) { %w[foo bar car].freeze }

  let(:client_1_wrapper) { Wrapper.new options_1 }
  let(:client_2_wrapper) { Wrapper.new options_2 }

  let :options_1 do
    Tox::Options.new.tap do |options|
      options.local_discovery_enabled = false
    end
  end

  let :options_2 do
    Tox::Options.new.tap do |options|
      options.local_discovery_enabled = false
    end
  end

  before do
    nodes_1 = FAKE_NODES
    nodes_2 = FAKE_NODES

    tcp_relays_1 = FAKE_TCP_RELAYS
    tcp_relays_2 = FAKE_TCP_RELAYS

    client_1_wrapper.friend_add_norequest client_2_wrapper.public_key
    client_2_wrapper.friend_add_norequest client_1_wrapper.public_key

    nodes_1.each do |node|
      client_1_wrapper.bootstrap node.resolv_ipv4, node.port, node.public_key
    end

    nodes_2.each do |node|
      client_2_wrapper.bootstrap node.resolv_ipv4, node.port, node.public_key
    end

    tcp_relays_1.each do |tcp_relay|
      tcp_relay[:ports].each do |port|
        client_1_wrapper.add_tcp_relay '127.0.0.1', port, tcp_relay[:public_key]
      end
    end

    tcp_relays_2.each do |tcp_relay|
      tcp_relay[:ports].each do |port|
        client_2_wrapper.add_tcp_relay '127.0.0.1', port, tcp_relay[:public_key]
      end
    end

    client_1_wrapper.async.run
    client_2_wrapper.async.run

    messages.each do |text|
      client_1_wrapper.send_friend_message text
    end

    begin
      Timeout.timeout 20 do
        sleep 0.01 while client_2_wrapper.friend_messages.count < messages.count
      end
    rescue Timeout::Error
      nil
    end
  end

  after do
    client_1_wrapper.terminate
    client_2_wrapper.terminate
  end

  specify do
    expect(client_2_wrapper.friend_messages.to_set).to eq messages.to_set
  end
end
