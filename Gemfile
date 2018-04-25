# frozen_string_literal: true

require_relative 'vendor'

source 'https://rubygems.org'

# Specify your gem's dependencies in tox.gemspec
gemspec

gem 'coveralls', group: :test, require: false

group :development, :test do
  gem 'gstreamer', '~> 3.2'
end

group :examples do
  gem 'gtk3', '~> 3.2'
end
