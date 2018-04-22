# frozen_string_literal: true

require 'gst'

Gst::Registry.get.scan_path File.expand_path '../..', __dir__
