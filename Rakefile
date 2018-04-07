# frozen_string_literal: true

require 'bundler/gem_tasks'

VENDOR_PREFIX = File.expand_path('vendor', __dir__).freeze

VENDOR_PKG_CONFIG_PATH = File.join(VENDOR_PREFIX, 'lib', 'pkgconfig').freeze

desc 'Run all checks (test, lint...)'
task default: %i[test lint]

desc 'Run all tests (specs, benchmarks...)'
task test: :spec

desc 'Run all code analysis tools (RuboCop...)'
task lint: :rubocop

desc 'Fix code style (rubocop --auto-correct)'
task fix: 'rubocop:auto_correct'

desc 'Compile all extensions (and their dependencies)'
task ext: %i[ext:tox]

require 'pry'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
  Rake::Task[:spec].enhance %i[ext]
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

  Rake::Task[:compile].clear_comments
  Rake::Task['compile:tox'].clear_comments
rescue LoadError
  nil
end

namespace :ext do
  desc 'Compile "tox" extension (and it\'s dependencies)'
  task tox: %i[
    vendor/lib/pkgconfig/libtoxcore.pc
    compile:tox
  ]
end

namespace :vendor do
  desc 'Install vendored dependencies into "./vendor/{bin,include,lib}/"'
  task install: %i[install:libsodium install:libtoxcore]

  desc 'Uninstall vendored dependencies from "./vendor/{bin,include,lib}/"'
  task :uninstall do
    rm_rf File.join VENDOR_PREFIX, 'bin'
    rm_rf File.join VENDOR_PREFIX, 'include'
    rm_rf File.join VENDOR_PREFIX, 'lib'
  end

  desc 'Delete compiled vendored dependencies from "./vendor/"'
  task clean: %i[uninstall clean:libsodium clean:libtoxcore]

  namespace :install do
    task libsodium: 'vendor/lib/pkgconfig/libsodium.pc'
    task libtoxcore: 'vendor/lib/pkgconfig/libtoxcore.pc'
  end

  namespace :clean do
    task :libsodium do
      chdir 'vendor/src/libsodium' do
        sh 'make clean'
      end
    end

    task :libtoxcore do
      chdir 'vendor/src/libtoxcore' do
        sh 'make clean'
      end
    end
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
       %i[vendor/src/libtoxcore/configure
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
