# frozen_string_literal: true

require_relative 'vendor'

require 'bundler/gem_tasks'

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
    ext.config_options << "--with-opt-dir=#{Vendor::PREFIX.shellescape}"
  end

  Rake::ExtensionTask.new 'gst-plugins-tox' do |ext|
    ext.lib_dir = File.expand_path('lib', __dir__).freeze
    ext.config_options << "--with-opt-dir=#{Vendor::PREFIX.shellescape}"
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
    install:gstreamer
    install:gst-plugins-base
  ]

  desc 'Uninstall vendored dependencies from "./vendor/{bin,include,lib}/"'
  task uninstall: %i[
    uninstall:libsodium
    uninstall:opus
    uninstall:libvpx
    uninstall:libtoxcore
    uninstall:gstreamer
    uninstall:gst-plugins-base
  ]

  desc 'Delete compiled vendored dependencies from "./vendor/"'
  task clean: %i[
    clean:libsodium
    clean:opus
    clean:libvpx
    clean:libtoxcore
    clean:gstreamer
    clean:gst-plugins-base
  ]

  desc 'Delete configured vendored dependencies from "./vendor/"'
  task distclean: %i[
    distclean:libsodium
    distclean:opus
    distclean:libvpx
    distclean:libtoxcore
    distclean:gstreamer
    distclean:gst-plugins-base
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

    task gstreamer: 'vendor/src/gstreamer/Makefile' do
      chdir 'vendor/src/gstreamer' do
        sh 'make install'
      end
    end

    task 'gst-plugins-base': 'vendor/src/gst-plugins-base/Makefile' do
      chdir 'vendor/src/gst-plugins-base' do
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

    task gstreamer: 'vendor/src/gstreamer/Makefile' do
      chdir 'vendor/src/gstreamer' do
        sh 'make uninstall'
      end
    end

    task 'gst-plugins-base': 'vendor/src/gst-plugins-base/Makefile' do
      chdir 'vendor/src/gst-plugins-base' do
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

    task gstreamer: 'vendor/src/gstreamer/Makefile' do
      chdir 'vendor/src/gstreamer' do
        sh 'make clean'
      end
    end

    task 'gst-plugins-base': 'vendor/src/gst-plugins-base/Makefile' do
      chdir 'vendor/src/gst-plugins-base' do
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

    task gstreamer: 'vendor/src/gstreamer/Makefile' do
      chdir 'vendor/src/gstreamer' do
        sh 'make distclean'
      end
    end

    task 'gst-plugins-base': 'vendor/src/gst-plugins-base/Makefile' do
      chdir 'vendor/src/gst-plugins-base' do
        sh 'make distclean'
      end
    end
  end
end

file 'vendor/src/libsodium/Makefile': 'vendor/src/libsodium/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      Vendor::PREFIX,

      '--enable-shared',
      '--disable-static',
    )
  end
end

file 'vendor/src/opus/Makefile': 'vendor/src/opus/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      Vendor::PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-extra-programs',
    )
  end
end

file 'vendor/src/libvpx/Makefile': 'vendor/src/libvpx/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      "--prefix=#{Vendor::PREFIX}",

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
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      Vendor::PREFIX,

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

file 'vendor/src/gstreamer/Makefile': 'vendor/src/gstreamer/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      Vendor::PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-gtk-doc',
      '--disable-nls',
      '--disable-examples',
      '--disable-tests',
      '--disable-benchmarks',
      '--disable-check',
      '--disable-poisoning',

      '--enable-rpath',
      '--enable-option-parsing',
      '--enable-gst-debug',
      '--enable-gst-tracer-hooks',
      '--enable-registry',
      '--enable-plugin',
      '--enable-tools',
      '--enable-introspection=yes',
      '--enable-extra-checks',
      '--enable-gobject-cast-checks=yes',
      '--enable-glib-asserts=yes',
    )
  end
end

file 'vendor/src/gst-plugins-base/Makefile':
  'vendor/src/gst-plugins-base/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => Vendor::PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      Vendor::PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-gtk-doc',
      '--disable-nls',
      '--disable-examples',
      '--disable-external',
      '--disable-experimental',
      '--disable-static-plugins',

      '--enable-rpath',
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

file 'vendor/src/gstreamer/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh', '--noconfigure'
  end
end

file 'vendor/src/gst-plugins-base/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh', '--noconfigure'
  end
end
