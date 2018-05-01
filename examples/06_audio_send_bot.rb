#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'
require 'opus_file'

NAME = 'AudioSendBot'
STATUS_MESSAGE = 'Call me'

TEST_FILE = File.expand_path('../multimedia/test.opus', __dir__).freeze

AUDIO_BIT_RATE = 48

opus_files = {}

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

  friend_call_request.answer AUDIO_BIT_RATE, nil

  opus_files[friend_call_request.friend_number] = OpusFile.new TEST_FILE
end

tox_client.audio_video.on_call_state_change do |friend_call, friend_call_state|
  next unless friend_call_state.error? || friend_call_state.finished?
  opus_files[friend_call.friend_number] = nil
end

tox_client.audio_video.on_audio_frame do |friend_call, _audio_frame|
  new_audio_frame = Tox::AudioFrame.new

  opus_file = opus_files[friend_call.friend_number]

  next if opus_file.nil?

  unless opus_file.pcm_total(-1) > opus_file.pcm_tell
    puts 'EOF, seeking to start'
    puts

    opus_file.pcm_seek 0
  end

  new_audio_frame.pcm           = opus_file.read 1920
  new_audio_frame.sample_count  = 960
  new_audio_frame.channels      = 2
  new_audio_frame.sampling_rate = AUDIO_BIT_RATE * 1000

  begin
    friend_call.send_audio_frame new_audio_frame
  rescue
    # Just ignore errors.
    nil
  end
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
