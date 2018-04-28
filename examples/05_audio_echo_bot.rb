#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'

NAME = 'AudioVideoEchoBot'
STATUS_MESSAGE = 'Call me'

AUDIO_BIT_RATE = 48

tox_client = Tox::Client.new

tox_client.name = NAME
tox_client.status = Tox::UserStatus::NONE
tox_client.status_message = STATUS_MESSAGE

puts "Address: #{tox_client.address}"

puts 'Connecting to the nodes from official list...'
tox_client.bootstrap_official

tox_client.on_friend_request do |public_key, text|
  puts 'Friend request. Adding to contacts...'
  puts "Public key: #{public_key}"
  puts "Text:       #{text.inspect}"
  puts

  tox_client.friend_add_norequest public_key
end

tox_client.audio_video.on_call \
do |friend_call_request, audio_enabled, video_enabled|
  puts 'Friend call. Answering...'
  puts "Friend number: #{friend_call_request.friend_number}"
  puts "Audio enabled: #{audio_enabled}"
  puts "Video enabled: #{video_enabled}"
  puts

  friend_call_request.answer(
    audio_enabled ? AUDIO_BIT_RATE : nil,
    nil,
  )
end

tox_client.audio_video.on_audio_frame do |friend_call, audio_frame|
  friend_call.send_audio_frame audio_frame
end

puts 'Running. Send me friend request, I\'ll accept it immediately. ' \
     'Then call me.'

puts

Thread.start do
  loop do
    sleep tox_client.audio_video.iteration_interval
    tox_client.audio_video.iterate
  end
end

begin
  loop do
    sleep tox_client.iteration_interval
    tox_client.iterate
  end
rescue Interrupt
  nil
end
