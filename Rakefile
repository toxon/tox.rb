# frozen_string_literal: true

require 'bundler/gem_tasks'

VENDOR_PREFIX = File.expand_path('vendor', __dir__).freeze

VENDOR_PKG_CONFIG_PATH = File.join(VENDOR_PREFIX, 'lib', 'pkgconfig').freeze

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

  Rake::ExtensionTask.new 'tox' do |ext|
    ext.lib_dir = 'lib/tox'
    ext.config_options << "--with-opt-dir=#{VENDOR_PREFIX.shellescape}"
  end
rescue LoadError
  nil
end

namespace :vendor do
  desc 'Build and install vendored dependencies into "./vendor/"'
  task install: %i[install:libsodium install:libtoxcore]

  desc 'Uninstall vendored dependencies from "./vendor/"'
  task :uninstall do
    rm_rf File.join VENDOR_PREFIX, 'bin'
    rm_rf File.join VENDOR_PREFIX, 'include'
    rm_rf File.join VENDOR_PREFIX, 'lib'
  end

  namespace :install do
    task libsodium: 'vendor/lib/pkgconfig/libsodium.pc'
    task libtoxcore: 'vendor/lib/pkgconfig/libtoxcore.pc'
  end
end

file 'vendor/lib/pkgconfig/libsodium.pc': 'vendor/src/libsodium/Makefile' do
  chdir 'vendor/src/libsodium' do
    sh 'make install'
  end
end

file 'vendor/lib/pkgconfig/libtoxcore.pc': 'vendor/src/libtoxcore/Makefile' do
  chdir 'vendor/src/libtoxcore' do
    sh 'make install'
  end
end

file 'vendor/src/libsodium/Makefile': 'vendor/src/libsodium/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,
    )
  end
end

file 'vendor/src/libtoxcore/Makefile':
       %w[vendor/src/libtoxcore/configure
          vendor/lib/pkgconfig/libsodium.pc] do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,
      '--enable-daemon',
    )
  end
end

file 'vendor/src/libsodium/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh'
  end
end

file 'vendor/src/libtoxcore/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh'
  end
end
