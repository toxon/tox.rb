#!/usr/bin/env ruby
# frozen_string_literal: true

# This bot accepts any friendship request, receives any file from user and
# saves it to "tmp/file_recv_bot_last_file"

require 'bundler/setup'

require 'tox'

REL_FILE_NAME = 'tmp/file_recv_bot_last_file'

NAME = 'FileRecvBot'
STATUS_MESSAGE = "Send me a file, I'll save it to \"#{REL_FILE_NAME}\""

FILE_NAME = File.expand_path(File.join('..', REL_FILE_NAME), __dir__).freeze

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

tox_client.on_file_recv_request \
do |in_friend_file, file_kind, file_size, filename|
  puts 'File receiving request.'
  puts "Friend number: #{in_friend_file.friend.number}"
  puts "File number:   #{in_friend_file.number}"
  puts "File kind:     #{file_kind}"
  puts "File size:     #{file_size}"
  puts "Filename:      #{filename}"
  puts

  unless $file.nil?
    puts 'Already receiving file. Cancelling...'
    puts

    in_friend_file.control Tox::FileControl::CANCEL
    next
  end

  if file_size.zero?
    puts 'Zero size. Cancelling...'
    puts

    in_friend_file.control Tox::FileControl::CANCEL
    next
  end

  puts 'Accepting file...'
  puts

  $file = File.open FILE_NAME, 'w'

  in_friend_file.control Tox::FileControl::RESUME
end

tox_client.on_file_recv_control do |in_friend_file, file_control|
  puts 'File receive control command.'
  puts "Friend number: #{in_friend_file.friend.number}"
  puts "File number:   #{in_friend_file.number}"
  puts "File control:  #{file_control}"
  puts

  next unless file_control == Tox::FileControl::CANCEL

  puts 'File transfer cancelled. Closing file...'
  puts

  $file.close
  $file = nil
end

tox_client.on_file_recv_chunk do |in_friend_file, position, data|
  puts 'File chunk received.'
  puts "Friend number: #{in_friend_file.friend.number}"
  puts "File number:   #{in_friend_file.number}"
  puts "Position:      #{position}"
  puts "Data length:   #{data.bytesize}"
  puts

  if data.bytesize.zero?
    puts 'Empty chunk. Closing file...'
    puts

    $file.close
    $file = nil

    next
  end

  if $file.nil?
    puts 'Not receiving file. Doint nothing...'
    puts

    next
  end

  puts 'Non-empty chunk. Writing to file...'
  puts

  $file.seek position
  $file.write data
end

puts 'Running. Send me friend request, I\'ll accept it immediately. ' \
     'Then send me a file.'

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
