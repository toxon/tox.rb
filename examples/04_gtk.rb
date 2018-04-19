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

def on_friends_tree_selection_changed_cb(selection)
  selected = selection.selected
  return if selected.nil?
  friend_number = selected[0]
  p friend_number
end

gtk_builder.connect_signals do |handler|
  method "on_#{handler}"
end

gtk_builder['main_window'].show_all

gtk_builder['friends_tree_view'].append_column(
  Gtk::TreeViewColumn.new('Name', Gtk::CellRendererText.new, text: 1),
)

friends_list_store = Gtk::ListStore.new Integer, String

gtk_builder['friends_tree_view'].model = friends_list_store

friends_list_store.append.set_values 0 => 0, 1 => 'Braiden Vasco'
friends_list_store.append.set_values 0 => 1, 1 => 'Satoshi Nakamoto'
friends_list_store.append.set_values 0 => 2, 1 => 'Elon Musk'

Gtk.main
