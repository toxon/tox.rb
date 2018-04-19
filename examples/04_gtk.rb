#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'gtk3'

GLADE_FILE = File.expand_path('ui.glade', __dir__).freeze

gtk_builder = Gtk::Builder.new

gtk_builder.add_from_file GLADE_FILE

def on_main_window_destroy_cb
  Gtk.main_quit
end

gtk_builder.connect_signals do |handler|
  method "on_#{handler}"
end

gtk_builder['main_window'].show_all

Gtk.main
