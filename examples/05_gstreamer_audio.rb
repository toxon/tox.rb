#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gst'

FILENAME = File.expand_path('test.mp3', __dir__).freeze

playbin = Gst::ElementFactory.make 'playbin'

if playbin.nil?
  puts 'Missing GStreamer plugin "playbin"'
  exit false
end

playbin.uri = Gst.filename_to_uri FILENAME

main_loop = GLib::MainLoop.new

bus = playbin.bus

bus.add_watch do |_bus, message|
  case message.type
  when Gst::MessageType::EOS
    main_loop.quit
  when Gst::MessageType::ERROR
    error, debug = message.parse_error
    puts "Debugging info: #{debug || :none}"
    puts "Error: #{error.message}"
    main_loop.quit
  end
  true
end

playbin.play

begin
  main_loop.run
rescue Interrupt
  puts 'Interrupt'
rescue => error
  puts "Error: #{error.message}"
ensure
  playbin.stop
end
