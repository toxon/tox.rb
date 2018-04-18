#!/usr/bin/env ruby
# frozen_string_literal: true

# This bot welcomes user every time when user appears online.

require 'bundler/setup'

require 'tox'

NAME = 'WelcomeBot'

savedata_filename = File.expand_path ARGV[0] if ARGV[0]

tox_options = Tox::Options.new

if savedata_filename && File.exist?(savedata_filename)
  puts "Loading savedata from #{savedata_filename}"
  tox_options.savedata = File.binread savedata_filename
end

tox_client = Tox::Client.new tox_options

tox_client.name = NAME
tox_client.status = Tox::UserStatus::NONE

puts
puts "Address:        #{tox_client.address}"
puts "Name:           #{tox_client.name}"
puts "Status:         #{tox_client.status}"
puts "Status message: #{tox_client.status_message}"
puts

puts 'Connecting to the nodes from official list...'
tox_client.bootstrap_official

tox_client.on_friend_request do |public_key, text|
  puts 'Friend request. Adding to contacts...'
  puts "Public key: #{public_key}"
  puts "Text:       #{text.inspect}"
  puts

  tox_client.friend_add_norequest public_key
end

tox_client.on_friend_connection_status_change do |friend, connection_status|
  puts 'Friend status changed.'
  puts "Number:         #{friend.number}"
  puts "Name:           #{friend.name}"
  puts "Public key:     #{friend.public_key}"
  puts "Status:         #{friend.status}"
  puts "Status message: #{friend.status_message}"

  case connection_status
  when Tox::ConnectionStatus::NONE
    puts 'Has gone offline.'
  when Tox::ConnectionStatus::UDP
    puts 'Become online with UDP.'
    friend.send_message 'Hello! You are just connected with UDP'
  when Tox::ConnectionStatus::TCP
    puts 'Become online with TCP.'
    friend.send_message 'Hello! You are just connected with TCP'
  end

  puts
end

puts 'Running. Send me friend request, I\'ll accept it immediately. ' \
     'Then send me a message.'

begin
  puts
  loop do
    sleep tox_client.iteration_interval
    tox_client.iterate
  end
  puts
rescue SignalException
  puts
end

if savedata_filename
  puts "Saving savedata to #{savedata_filename}"
  File.binwrite savedata_filename, tox_client.savedata
end
