# frozen_string_literal: true

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'tox/version'

Gem::Specification.new do |spec|
  spec.name     = 'tox'
  spec.version  = Tox::Version::GEM_VERSION
  spec.license  = 'GPL-3.0'
  spec.homepage = 'https://github.com/toxon/tox.rb'
  spec.summary  = 'Ruby interface for libtoxcore'
  spec.platform = Gem::Platform::RUBY

  spec.required_ruby_version = '~> 2.3'

  spec.authors = ['Braiden Vasco']
  spec.email   = %w[braiden-vasco@users.noreply.github.com]

  spec.description = <<-DESCRIPTION.split.join ' '
  Ruby interface for libtoxcore. It can be used to create Tox chat client or bot.
  The interface is object-oriented instead of C-style (raises exceptions
  instead of returning error codes, uses classes to represent primitives, etc.)
  DESCRIPTION

  spec.metadata = {
    'homepage_uri'    => 'https://github.com/toxon/tox.rb',
    'source_code_uri' => 'https://github.com/toxon/tox.rb',
    'bug_tracker_uri' => 'https://github.com/toxon/tox.rb/issues',
  }.freeze

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match %r{^(test|spec|features)/}
  end

  spec.bindir      = 'exe'
  spec.executables = spec.files.grep %r{^exe/}, &File.method(:basename)

  spec.extensions << 'ext/tox/extconf.rb'
  spec.extensions << 'ext/opus_file/extconf.rb'
  spec.extensions << 'ext/vorbis_file/extconf.rb'

  spec.add_development_dependency 'bundler',       '~> 1.13'
  spec.add_development_dependency 'celluloid',     '~> 0.17'
  spec.add_development_dependency 'faker',         '~> 1.8'
  spec.add_development_dependency 'pry',           '~> 0.10'
  spec.add_development_dependency 'rake',          '~> 10.0'
  spec.add_development_dependency 'rake-compiler', '~> 1.0'
  spec.add_development_dependency 'rspec',         '~> 3.6'
  spec.add_development_dependency 'rubocop',       '~> 0.55.0'
  spec.add_development_dependency 'simplecov',     '~> 0.14'
  spec.add_development_dependency 'yard',          '~> 0.9'
end
