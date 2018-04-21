#!/usr/bin/env ruby
# frozen_string_literal: true

# This bot accepts any friendship request and sends own source code
# when it receives any message from user.

require 'bundler/setup'

require 'tox'

NAME = 'FileSendBot'
STATUS_MESSAGE = 'Send me a message'

FILE_NAME = File.basename(__FILE__).freeze

file = File.open __FILE__, 'r'

tox_client = Tox::Client.new

tox_client.name = NAME
tox_client.status = Tox::UserStatus::NONE
tox_client.status_message = STATUS_MESSAGE

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

tox_client.on_friend_message do |friend, text|
  puts 'Message from friend'
  puts "Number:         #{friend.number}"
  puts "Name:           #{friend.name}"
  puts "Public key:     #{friend.public_key}"
  puts "Status:         #{friend.status}"
  puts "Status message: #{friend.status_message}"
  puts "Text:           #{text.inspect}"
  puts

  friend.send_file Tox::FileKind::DATA, file.size, FILE_NAME
end

tox_client.on_file_chunk_request do |out_friend_file, position, length|
  puts 'Chunk request'
  puts "Friend number: #{out_friend_file.friend.number}"
  puts "File number:   #{out_friend_file.number}"
  puts "Position:      #{position}"
  puts "Length:        #{length}"
  puts

  next if length.zero?

  file.seek position
  data = file.read length
  out_friend_file.send_chunk position, data
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
rescue Interrupt
  puts
end
