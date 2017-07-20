# coding: utf-8
# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'tox/version'

Gem::Specification.new do |spec|
  spec.name     = 'tox'
  spec.version  = Tox::VERSION
  spec.license  = 'GPL-3.0'
  spec.homepage = 'https://github.com/braiden-vasco/tox.rb'
  spec.summary  = 'Ruby interface for libtoxcore'
  spec.platform = Gem::Platform::RUBY

  spec.authors = ['Braiden Vasco']
  spec.email   = %w[braiden-vasco@users.noreply.github.com]

  spec.required_ruby_version = '~> 2.3'

  spec.description = <<-END.split.join ' '
  Ruby interface for libtoxcore. It can be used to create Tox chat client or bot.
  The interface is object-oriented instead of C-style (raises exceptions
  instead of returning error codes, uses classes to represent primitives, etc.)
  END

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match %r{^(test|spec|features)/}
  end

  spec.bindir      = 'exe'
  spec.executables = spec.files.grep %r{^exe/}, &File.method(:basename)

  spec.extensions << 'ext/tox/extconf.rb'

  spec.add_development_dependency 'bundler',       '~> 1.13'
  spec.add_development_dependency 'rake',          '~> 10.0'
  spec.add_development_dependency 'pry',           '~> 0.10'
  spec.add_development_dependency 'rubocop',       '~> 0.49.1'
  spec.add_development_dependency 'rspec',         '~> 3.6'
  spec.add_development_dependency 'simplecov',     '~> 0.14'
  spec.add_development_dependency 'yard',          '~> 0.9'
  spec.add_development_dependency 'rake-compiler', '~> 1.0'
end
