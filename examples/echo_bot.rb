#!/usr/bin/env ruby
# frozen_string_literal: true

# Simpliest program using toxcore. It connects to Tox, accepts any friendship
# request and returns received messages to user. Also if you provide savedata
# filename as the script argument it can restore private key from this file so
# it's address will not change between restarts.
#
# Based on implementation in C: https://github.com/braiden-vasco/ToxEcho

require 'bundler/setup'

require 'tox'

NAME = 'EchoBot'
STATUS_MESSAGE = 'Send me a message'

savedata_filename = File.expand_path ARGV[0] if ARGV[0]

tox_options = Tox::Options.new

if savedata_filename && File.exist?(savedata_filename)
  puts "Loading savedata from #{savedata_filename}"
  tox_options.savedata = File.binread savedata_filename
end

tox_client = Tox::Client.new tox_options

tox_client.name = NAME
tox_client.status_message = STATUS_MESSAGE

puts
puts "Address:        #{tox_client.address.to_hex}"
puts "Name:           #{tox_client.name}"
puts "Status message: #{tox_client.status_message}"
puts

puts 'Connecting to the nodes from official list...'
tox_client.bootstrap_official

tox_client.on_friend_request do |public_key|
  puts "Got friend request with public key #{public_key.to_hex}. Adding to contacts..."
  tox_client.friend_add_norequest public_key
end

tox_client.on_friend_message do |friend, text|
  puts "Got message from friend #{friend.number} (#{friend.public_key.to_hex}) " \
       "with text #{text.inspect}. Sending it back..."
  friend.send_message text
end

puts 'Running. Send me friend request, I\'ll accept it immediately. Then send me a message.'
begin
  puts
  tox_client.run
  puts
rescue SignalException
  puts
end

if savedata_filename
  puts "Saving savedata to #{savedata_filename}"
  File.binwrite savedata_filename, tox_client.savedata
end
