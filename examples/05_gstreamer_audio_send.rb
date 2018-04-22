#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'
require 'gst/plugins/tox'

FILENAME = File.expand_path('test.mp3', __dir__).freeze

filesrc        = Gst::ElementFactory.make 'filesrc'
mpegaudioparse = Gst::ElementFactory.make 'mpegaudioparse'
mpg123audiodec = Gst::ElementFactory.make 'mpg123audiodec'
audioresample  = Gst::ElementFactory.make 'audioresample'
opusenc        = Gst::ElementFactory.make 'opusenc'
toxaudiosink   = Gst::ElementFactory.make 'toxaudiosink'

elements = [
  filesrc,
  mpegaudioparse,
  mpg123audiodec,
  audioresample,
  opusenc,
  toxaudiosink,
]

unless elements.all?
  puts 'Cound not create some elements'
  exit
end

filesrc.location = FILENAME

pipeline = Gst::Pipeline.new

elements.inject(pipeline, &:<<) # pipeline << filesrc << mpegaudioparse << ...
elements.inject(&:>>)           # filesrc >> mpegaudioparse >> ...

main_loop = GLib::MainLoop.new

bus = pipeline.bus

bus.add_watch do |_bus, message|
  case message.type
  when Gst::MessageType::EOS
    main_loop.quit
  when Gst::MessageType::WARNING
    warning, debug = message.parse_warning
    puts "Debugging ingo: #{debug || :none}"
    puts "Warning: #{warning.message}"
  when Gst::MessageType::ERROR
    error, debug = message.parse_error
    puts "Debugging info: #{debug || :none}"
    puts "Error: #{error.message}"
    main_loop.quit
  end
  true
end

pipeline.play

begin
  main_loop.run
rescue Interrupt
  puts 'Interrupt'
rescue => error
  puts "Error: #{error.message}"
ensure
  pipeline.stop
end
