# frozen_string_literal: true

require 'English'

require 'bundler/gem_tasks'

VENDOR_PREFIX = File.expand_path('vendor', __dir__).freeze

VENDOR_PKG_CONFIG_PATH = File.join(VENDOR_PREFIX, 'lib', 'pkgconfig').freeze

VENDOR_REPOS = %w[
  libsodium
  opus
  libvpx
  libtoxcore
  glib
  gstreamer
  gst-plugins-base
  gst-plugins-good
].freeze

desc 'Run all checks (test, lint...)'
task default: %i[test lint]

desc 'Run all tests (specs, benchmarks...)'
task test: :spec

desc 'Run all code analysis tools (RuboCop...)'
task lint: :rubocop

desc 'Fix code style (rubocop --auto-correct)'
task fix: 'rubocop:auto_correct'

desc 'Print shared object dependencies'
task :ldd do
  puts(
    # Where builded shared object can be placed
    Dir[File.expand_path('{lib,vendor/bin,vendor/lib}/**/*')]                  \
      # Only select executable files
      .select(&File.method(:executable?))                                      \
      # Skip directories and symlinks which are executables too
      .select(&File.method(:file?))                                            \
      # Grab ldd output and exit status
      .map { |f| [f, `ldd #{f}`, $CHILD_STATUS.exitstatus] }                   \
      # Skip executable scripts
      .select { |_f, _result, exitstatus| exitstatus&.zero? }                  \
      # Format output
      .flat_map { |f, result, _| [f, *result.split("\n") .map(&:strip), nil] } \
      .join("\n"),
  )
end

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
  task install: VENDOR_REPOS.map { |s| "install:#{s}" }

  desc 'Uninstall vendored dependencies from "./vendor/{bin,include,lib}/"'
  task uninstall: VENDOR_REPOS.map { |s| "uninstall:#{s}" }

  desc 'Delete compiled vendored dependencies from "./vendor/"'
  task clean: VENDOR_REPOS.map { |s| "clean:#{s}" }

  desc 'Delete configured vendored dependencies from "./vendor/"'
  task distclean: VENDOR_REPOS.map { |s| "distclean:#{s}" }

  desc 'Remove untracked content from Git submodules'
  task gitfix: VENDOR_REPOS.map { |s| "gitfix:#{s}" }

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

    task glib: 'vendor/src/glib/Makefile' do
      chdir 'vendor/src/glib' do
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

    task 'gst-plugins-good': 'vendor/src/gst-plugins-good/Makefile' do
      chdir 'vendor/src/gst-plugins-good' do
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

    task glib: 'vendor/src/glib/Makefile' do
      chdir 'vendor/src/glib' do
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

    task 'gst-plugins-good': 'vendor/src/gst-plugins-good/Makefile' do
      chdir 'vendor/src/gst-plugins-good' do
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

    task glib: 'vendor/src/glib/Makefile' do
      chdir 'vendor/src/glib' do
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

    task 'gst-plugins-good': 'vendor/src/gst-plugins-good/Makefile' do
      chdir 'vendor/src/gst-plugins-good' do
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

    task glib: 'vendor/src/glib/Makefile' do
      chdir 'vendor/src/glib' do
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

    task 'gst-plugins-good': 'vendor/src/gst-plugins-good/Makefile' do
      chdir 'vendor/src/gst-plugins-good' do
        sh 'make distclean'
      end
    end
  end

  namespace :gitfix do
    task :libsodium
    task :opus
    task :libvpx
    task :libtoxcore

    task :glib do
      chdir 'vendor/src/glib' do
        rm_f 'gio/gvdb/.dirstamp'
        rm_f 'glib/deprecated/.dirstamp'
      end
    end

    task :gstreamer do
      chdir 'vendor/src/gstreamer' do
        sh 'git', 'checkout', '.'
      end
    end

    task 'gst-plugins-base' do
      chdir 'vendor/src/gst-plugins-base' do
        sh 'git', 'checkout', '.'
      end
    end

    task 'gst-plugins-good' do
      chdir 'vendor/src/gst-plugins-good' do
        sh 'git', 'checkout', '.'
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

file 'vendor/src/glib/Makefile': 'vendor/src/glib/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-installed-tests',
      '--disable-always-build-tests',
      '--disable-largefile',
      '--disable-selinux',
      '--disable-fam',
      '--disable-xattr',
      '--disable-libelf',
      '--disable-libmount',
      '--disable-man',
      '--disable-dtrace',
      '--disable-systemtap',
      '--disable-coverage',
    )
  end
end

file 'vendor/src/gstreamer/Makefile': 'vendor/src/gstreamer/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

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
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-gtk-doc',
      '--disable-nls',
      '--disable-examples',
      '--disable-experimental',
      '--disable-static-plugins',

      '--enable-rpath',
      '--enable-external',
      '--enable-opus',
    )
  end
end

file 'vendor/src/gst-plugins-good/Makefile':
  'vendor/src/gst-plugins-good/configure' do |t|
  chdir File.dirname t.name do
    sh(
      { 'PKG_CONFIG_PATH' => VENDOR_PKG_CONFIG_PATH },
      './configure',
      '--prefix',
      VENDOR_PREFIX,

      '--enable-shared',
      '--disable-static',

      '--disable-gtk-doc',
      '--disable-nls',
      '--disable-examples',
      '--disable-experimental',
      '--disable-static-plugins',

      '--enable-rpath',
      '--enable-external',

      # Required plugins
      '--enable-audioparsers', # mpegaudioparse

      # Unnecessary plugins
      '--disable-alpha',
      '--disable-apetag',
      '--disable-audiofx',
      '--disable-auparse',
      '--disable-autodetect',
      '--disable-avi',
      '--disable-cutter',
      '--disable-debugutils',
      '--disable-deinterlace',
      '--disable-dtmf',
      '--disable-effectv',
      '--disable-equalizer',
      '--disable-flv',
      '--disable-flx',
      '--disable-goom',
      '--disable-goom2k1',
      '--disable-icydemux',
      '--disable-id3demux',
      '--disable-imagefreeze',
      '--disable-interleave',
      '--disable-isomp4',
      '--disable-law',
      '--disable-level',
      '--disable-matroska',
      '--disable-monoscope',
      '--disable-multifile',
      '--disable-multipart',
      '--disable-replaygain',
      '--disable-rtp',
      '--disable-rtpmanager',
      '--disable-rtsp',
      '--disable-shapewipe',
      '--disable-smpte',
      '--disable-spectrum',
      '--disable-udp',
      '--disable-videobox',
      '--disable-videocrop',
      '--disable-videofilter',
      '--disable-videomixer',
      '--disable-wavenc',
      '--disable-wavparse',
      '--disable-y4m',
      '--disable-directsound',
      '--disable-waveform',
      '--disable-oss',
      '--disable-oss4',
      '--disable-sunaudio',
      '--disable-osx_audio',
      '--disable-osx_video',
      '--disable-gst_v4l2',
      '--disable-v4l2-probe',
      '--disable-x',
      '--disable-aalib',
      '--disable-aalibtest',
      '--disable-cairo',
      '--disable-flac',
      '--disable-gdk_pixbuf',
      '--disable-jack',
      '--disable-jpeg',
      '--disable-libcaca',
      '--disable-libdv',
      '--disable-libpng',
      '--disable-pulse',
      '--disable-dv1394',
      '--disable-shout2',
      '--disable-soup',
      '--disable-speex',
      '--disable-taglib',
      '--disable-vpx',
      '--disable-wavpack',
      '--disable-zlib',
      '--disable-bz2',
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

file 'vendor/src/glib/configure' do |t|
  chdir File.dirname t.name do
    sh({ 'NOCONFIGURE' => 'yes' }, './autogen.sh')
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

file 'vendor/src/gst-plugins-good/configure' do |t|
  chdir File.dirname t.name do
    sh './autogen.sh', '--noconfigure'
  end
end
