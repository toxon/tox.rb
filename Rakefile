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

namespace :vendor do
  task :libsodium do
    chdir 'vendor/libsodium' do
      sh './autogen.sh'
      sh './configure'
      sh 'make'
      sh 'sudo make install'
    end
  end

  task :libtoxcore do
    chdir 'vendor/libtoxcore' do
      sh './autogen.sh'
      sh './configure'
      sh 'make'
      sh 'sudo make install'
    end
  end
end
