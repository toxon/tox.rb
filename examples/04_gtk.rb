#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

require 'tox'
require 'gtk3'

NAME = 'GTK Client'

GLADE_FILE = File.expand_path('ui.glade', __dir__).freeze

Thread.abort_on_exception = true

$current_friend_number = nil

$friends_list_store = Gtk::ListStore.new Integer, String
$message_text_buffer = Gtk::TextBuffer.new

$tox_client = Tox::Client.new

$tox_client.name = NAME
$tox_client.status = Tox::UserStatus::NONE

puts "Address: #{$tox_client.address}"

puts 'Connecting to the nodes from official list...'
$tox_client.bootstrap_official

$tox_client.on_friend_request do |public_key, _text|
  friend = $tox_client.friend_add_norequest public_key
  $friends_list_store.append.set_values 0 => friend.number
end

gtk_builder = Gtk::Builder.new

gtk_builder.add_from_file GLADE_FILE

def on_main_window_destroy_cb
  Gtk.main_quit
end

def on_friends_tree_selection_changed_cb(selection)
  selected = selection.selected
  return $current_friend_number = nil if selected.nil?
  $current_friend_number = selected[0]
end

def on_send_button_clicked_cb(_)
  return if $current_friend_number.nil?
  text = $message_text_buffer.text
  return if text.empty?
  $tox_client.friend($current_friend_number).send_message text
  $message_text_buffer.text = ''
end

gtk_builder.connect_signals do |handler|
  method "on_#{handler}"
end

gtk_builder['main_window'].show_all

gtk_builder['friends_tree_view'].append_column(
  Gtk::TreeViewColumn.new('#', Gtk::CellRendererText.new, text: 0),
)

gtk_builder['friends_tree_view'].model = $friends_list_store
gtk_builder['message_text_view'].buffer = $message_text_buffer

puts 'Running. Send me friend request, I\'ll accept it immediately.'

Thread.start do
  loop do
    sleep $tox_client.iteration_interval
    $tox_client.iterate
  end
end

Gtk.main
