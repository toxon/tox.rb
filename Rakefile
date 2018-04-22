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

  Rake::ExtensionTask.new 'gst-plugins-tox' do |ext|
    ext.lib_dir = File.expand_path('lib', __dir__).freeze
    ext.config_options << "--with-opt-dir=#{VENDOR_PREFIX.shellescape}"
  end
rescue LoadError
  nil
end

namespace :vendor do
  desc 'Install vendored dependencies into "./vendor/{bin,include,lib}/"'
  task install: %i[
    install:libsodium
    install:opus
    install:libvpx
    install:libtoxcore
  ]

  desc 'Uninstall vendored dependencies from "./vendor/{bin,include,lib}/"'
  task uninstall: %i[
    uninstall:libsodium
    uninstall:opus
    uninstall:libvpx
    uninstall:libtoxcore
  ]

  desc 'Delete compiled vendored dependencies from "./vendor/"'
  task clean: %i[
    clean:libsodium
    clean:opus
    clean:libvpx
    clean:libtoxcore
  ]

  desc 'Delete configured vendored dependencies from "./vendor/"'
  task distclean: %i[
    distclean:libsodium
    distclean:opus
    distclean:libvpx
    distclean:libtoxcore
  ]

  namespace :install do
    task libsodium: 'vendor/src/libsodium/Makefile' do
      chdir 'vendor/src/libsodium' do
        sh 'make install'
      end
    end

    task opus: 'vendor/src/opus/Makefile' do
      chdir 'vendor/src/opus' do
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

    task opus: 'vendor/src/opus/Makefile' do
      chdir 'vendor/src/opus' do
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

    task opus: 'vendor/src/opus/Makefile' do
      chdir 'vendor/src/opus' do
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

    task opus: 'vendor/src/opus/Makefile' do
      chdir 'vendor/src/opus' do
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

file 'vendor/src/opus/Makefile': 'vendor/src/opus/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-extra-programs',
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
      '--disable-tools',
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

file 'vendor/src/opus/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh'
  end
end

file 'vendor/src/libtoxcore/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh'
  end
end
