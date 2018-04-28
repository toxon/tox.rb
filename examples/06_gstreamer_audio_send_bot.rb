#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'
require 'gst/plugins/tox'

class StreamingThread
  FILENAME = File.expand_path('test.mp3', __dir__).freeze

  attr_reader :tox_audio_video, :friend_number

  def initialize(tox_audio_video, friend_number)
    @tox_audio_video = tox_audio_video
    @friend_number = friend_number

    raise unless elements.all?

    Thread.start(&method(:call))
  end

private

  def call
    bus # add loop event handler

    pipeline.play
    main_loop.run
  ensure
    pipeline.stop
  end

  def main_loop
    @main_loop ||= GLib::MainLoop.new
  end

  def pipeline
    @pipeline ||= Gst::Pipeline.new.tap do |pipeline|
      elements.inject(pipeline, &:<<)
      elements.inject(&:>>)
    end
  end

  def bus
    @bus ||= pipeline.bus.tap do |bus|
      bus.add_watch do |_bus, message|
        case message.type
        when Gst::MessageType::EOS, Gst::MessageType::ERROR
          main_loop.quit
        end
        true
      end
    end
  end

  def elements
    @elements ||= [
      filesrc,
      mpegaudioparse,
      mpg123audiodec,
      audioresample,
      toxaudiosink,
    ].freeze
  end

  def filesrc
    @filesrc ||= Gst::ElementFactory.make('filesrc')&.tap do |elem|
      elem.location = FILENAME
    end
  end

  def mpegaudioparse
    @mpegaudioparse ||= Gst::ElementFactory.make 'mpegaudioparse'
  end

  def mpg123audiodec
    @mpg123audiodec ||= Gst::ElementFactory.make 'mpg123audiodec'
  end

  def audioresample
    @audioresample ||= Gst::ElementFactory.make 'audioresample'
  end

  def toxaudiosink
    @toxaudiosink ||= Gst::ElementFactory.make('toxaudiosink')&.tap do |elem|
      elem.tox_av = tox_audio_video.pointer
      elem.friend_number = friend_number
    end
  end
end

NAME = 'GStreamerAudioSendBot'
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

tox_client.audio_video.on_call do |friend_call_request|
  puts 'Friend call. Answering...'
  puts "Friend number: #{friend_call_request.friend_number}"
  puts "Audio enabled: #{friend_call_request.audio_enabled?}"
  puts "Video enabled: #{friend_call_request.video_enabled?}"
  puts

  friend_call_request.answer(
    friend_call_request.audio_enabled? ? AUDIO_BIT_RATE : nil,
    nil,
  )

  StreamingThread.new(
    friend_call_request.audio_video,
    friend_call_request.friend_number,
  )
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
