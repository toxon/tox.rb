#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'

NAME = 'AudioVideoEchoBot'
STATUS_MESSAGE = 'Call me'

AUDIO_BIT_RATE = 48
VIDEO_BIT_RATE = 5000

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

tox_client.audio_video.on_call do |friend_call_request|
  puts 'Friend call.'
  puts "Friend number: #{friend_call_request.friend_number}"
  puts "Audio enabled: #{friend_call_request.audio_enabled?}"
  puts "Video enabled: #{friend_call_request.video_enabled?}"
  puts

  unless friend_call_request.audio_enabled? ||
         friend_call_request.video_enabled?
    puts 'Both audio and video disabled. Rejecting...'
    puts

    friend_call_request.reject
    next
  end

  friend_call_request.answer(
    friend_call_request.audio_enabled? ? AUDIO_BIT_RATE : nil,
    friend_call_request.video_enabled? ? VIDEO_BIT_RATE : nil,
  )
end

tox_client.audio_video.on_audio_frame do |friend_call, audio_frame|
  # Here we create new instance of {Tox::AudioFrame} from given one
  # to demonstrate it's public interface. This is not required,
  # we can resend the given one.

  new_audio_frame = Tox::AudioFrame.new

  new_audio_frame.pcm           = audio_frame.pcm
  new_audio_frame.sample_count  = audio_frame.sample_count
  new_audio_frame.channels      = audio_frame.channels
  new_audio_frame.sampling_rate = audio_frame.sampling_rate

  friend_call.send_audio_frame new_audio_frame
end

tox_client.audio_video.on_video_frame do |friend_call, video_frame|
  friend_call.send_video_frame video_frame
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
