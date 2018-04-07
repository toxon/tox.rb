# frozen_string_literal: true

require 'bundler/gem_tasks'

GEMSPEC = Gem::Specification.load 'lita-tox.gemspec'

task default: %i[compile spec lint]

task lint: :rubocop

task fix: 'rubocop:auto_correct'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
rescue LoadError
  nil
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  nil
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  nil
end

begin
  require 'rake/extensiontask'

  Rake::ExtensionTask.new 'tox', GEMSPEC do |ext|
    ext.lib_dir = 'lib/tox'
  end
rescue LoadError
  nil
end

VENDOR_PREFIX = File.expand_path('vendor', __dir__).freeze

VENDOR_PKG_CONFIG_PATH = File.join(VENDOR_PREFIX, 'lib', 'pkgconfig').freeze

namespace :vendor do
  task :libsodium do
    chdir 'vendor/src/libsodium' do
      sh './autogen.sh'

      sh(
        { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
        './configure',
        '--prefix',
        VENDOR_PREFIX,
      )

      sh 'make install'
    end
  end

  task :libtoxcore do
    chdir 'vendor/src/libtoxcore' do
      sh './autogen.sh'

      sh(
        { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
        './configure',
        '--prefix',
        VENDOR_PREFIX,
        '--enable-daemon',
      )

      sh 'make install'
    end
  end
end
