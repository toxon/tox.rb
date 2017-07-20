#!/usr/bin/env ruby
# frozen_string_literal: true

# Simpliest program using toxcore. It connects to Tox, accepts any friendship
# request and returns received messages to user. Also if you provide savedata
# filename as the script argument it can restore private key from this file so
# it's ID will not change between restarts.
#
# Based on implementation in C: https://github.com/braiden-vasco/ToxEcho

require 'bundler/setup'

require 'tox'

NAME = 'EchoBot'

savedata_filename = File.expand_path ARGV[0] if ARGV[0]

tox_options = Tox::Options.new

if savedata_filename && File.exist?(savedata_filename)
  puts "Loading savedata from #{savedata_filename}"
  tox_options.savedata = File.binread savedata_filename
end

tox_client = Tox::Client.new tox_options

tox_client.name = NAME

puts "ID:   #{tox_client.id}"
puts "Name: #{tox_client.name}"

puts 'Connecting to the nodes from official list...'
tox_client.bootstrap_official

tox_client.on_friend_request do |public_key|
  puts "Got friend request wuth public key #{public_key}. Adding to contacts..."
  tox_client.friend_add_norequest public_key
end

tox_client.on_friend_message do |friend, text|
  puts "Got message from friend number #{friend.number} with text #{text.inspect}. Sending it back..."
  friend.send_message text
end

puts 'Running. Send me friend request, I\'ll accept it immediately. Then send me a message.'
begin
  tox_client.run
rescue SignalException
  nil
end

if savedata_filename
  puts "Saving savedata to #{savedata_filename}"
  File.binwrite savedata_filename, tox_client.savedata
end
