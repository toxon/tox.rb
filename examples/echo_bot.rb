#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'

tox_client = Tox::Client.new

puts "ID: #{tox_client.id}"

puts 'Connecting to the nodes from official list...'
tox_client.bootstrap_official

tox_client.on_friend_request do |public_key|
  puts "Got friend request wuth public key #{public_key}. Adding to contacts..."
  tox_client.friend_add_norequest public_key
end

tox_client.on_friend_message do |friend_number, text|
  puts "Got message from friend number #{friend_number} with text #{text.inspect}. Sending it back..."
  tox_client.friend_send_message friend_number, text
end

puts 'Running. Send me friend request, I\'ll accept it immediately. Then send me a message.'
tox_client.loop
