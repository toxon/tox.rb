# frozen_string_literal: true

require 'bundler/gem_tasks'

VENDOR_PREFIX = File.expand_path('vendor', __dir__).freeze

VENDOR_PKG_CONFIG_PATH = File.join(VENDOR_PREFIX, 'lib', 'pkgconfig').freeze

VENDOR_REPOS = %w[
  libsodium
  libvpx
  libtoxcore
].freeze

CLOBBER << 'coverage' << 'doc' << '.yardoc'

desc 'Run all checks (test, lint...)'
task default: %i[test lint]

desc 'Run all tests (specs, benchmarks...)'
task test: :spec

desc 'Run all code analysis tools (RuboCop...)'
task lint: :rubocop

desc 'Fix code style (rubocop --auto-correct)'
task fix: 'rubocop:auto_correct'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
  Rake::Task[:spec].enhance %i[compile]
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
    ext.lib_dir = File.expand_path('lib/tox', __dir__).freeze
    ext.config_options << "--with-opt-dir=#{VENDOR_PREFIX.shellescape}"
  end

  Rake::ExtensionTask.new 'opus_file' do |ext|
    ext.lib_dir = File.expand_path('lib', __dir__).freeze
  end

  Rake::ExtensionTask.new 'vorbis_file' do |ext|
    ext.lib_dir = File.expand_path('lib', __dir__).freeze
  end
rescue LoadError
  nil
end

namespace :vendor do
  desc 'Install vendored dependencies into "./vendor/{bin,include,lib}/"'
  task install: VENDOR_REPOS.map { |s| "install:#{s}" }

  desc 'Uninstall vendored dependencies from "./vendor/{bin,include,lib}/"'
  task uninstall: VENDOR_REPOS.map { |s| "uninstall:#{s}" }

  desc 'Delete compiled vendored dependencies from "./vendor/"'
  task clean: VENDOR_REPOS.map { |s| "clean:#{s}" }

  desc 'Delete configured vendored dependencies from "./vendor/"'
  task distclean: VENDOR_REPOS.map { |s| "distclean:#{s}" }

  namespace :install do
    task libsodium: 'vendor/src/libsodium/Makefile' do
      chdir 'vendor/src/libsodium' do
        sh 'make install'
      end
    end

    task libvpx: 'vendor/src/libvpx/Makefile' do
      chdir 'vendor/src/libvpx' do
        sh 'make install'
      end
    end

    task libtoxcore: 'vendor/src/libtoxcore/Makefile' do
      chdir 'vendor/src/libtoxcore' do
        sh 'make install'
      end
    end
  end

  namespace :uninstall do
    task libsodium: 'vendor/src/libsodium/Makefile' do
      chdir 'vendor/src/libsodium' do
        sh 'make uninstall'
      end
    end

    task libvpx: 'vendor/src/libvpx/Makefile' do
      chdir 'vendor/src/libvpx' do
        sh 'make uninstall'
      end
    end

    task libtoxcore: 'vendor/src/libtoxcore/Makefile' do
      chdir 'vendor/src/libtoxcore' do
        sh 'make uninstall'
      end
    end
  end

  namespace :clean do
    task libsodium: 'vendor/src/libsodium/Makefile' do
      chdir 'vendor/src/libsodium' do
        sh 'make clean'
      end
    end

    task libvpx: 'vendor/src/libvpx/Makefile' do
      chdir 'vendor/src/libvpx' do
        sh 'make clean'
      end
    end

    task libtoxcore: 'vendor/src/libtoxcore/Makefile' do
      chdir 'vendor/src/libtoxcore' do
        sh 'make clean'
      end
    end
  end

  namespace :distclean do
    task libsodium: 'vendor/src/libsodium/Makefile' do
      chdir 'vendor/src/libsodium' do
        sh 'make distclean'
      end
    end

    task libvpx: 'vendor/src/libvpx/Makefile' do
      chdir 'vendor/src/libvpx' do
        sh 'make distclean'
      end
    end

    task libtoxcore: 'vendor/src/libtoxcore/Makefile' do
      chdir 'vendor/src/libtoxcore' do
        sh 'make distclean'
      end
    end
  end
end

file 'vendor/src/libsodium/Makefile': 'vendor/src/libsodium/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',
    )
  end
end

file 'vendor/src/libvpx/Makefile': 'vendor/src/libvpx/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      "--prefix=#{VENDOR_PREFIX}",

      '--enable-shared',
      '--disable-static',

      '--disable-examples',
      '--disable-docs',
      '--disable-unit-tests',
    )
  end
end

file 'vendor/src/libtoxcore/Makefile': 'vendor/src/libtoxcore/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-tests',
      '--disable-dht-bootstrap',
      '--disable-testing',

      '--enable-daemon',
      '--enable-av',
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
