# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'tox/version'

Gem::Specification.new do |spec|
  spec.name     = 'tox'
  spec.version  = Tox::VERSION
  spec.license  = 'MIT'
  spec.homepage = 'https://github.com/braiden-vasco/tox.rb'
  spec.summary  = 'libtoxcore adapter for Ruby'

  spec.authors = ['Braiden Vasco']
  spec.email   = %w[braiden-vasco@users.noreply.github.com]

  spec.required_ruby_version = '~> 2.3'

  spec.description = <<-END.split.join ' '
  libtoxcore adapter for Ruby.
  END

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match %r{^(test|spec|features)/}
  end

  spec.bindir      = 'exe'
  spec.executables = spec.files.grep %r{^exe/}, &File.method(:basename)

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake',    '~> 10.0'
end
