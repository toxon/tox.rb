# frozen_string_literal: true

require 'open3'

module Support
  module FakeBootstrapNode
    class Process
      ROOT_DIR = File.expand_path('../../..', __dir__).freeze

      WRAPPER_FILE_PATH = File.expand_path('bin/childprocess', ROOT_DIR).freeze

      DAEMON_FILE_PATH = File.expand_path(
        'vendor/bin/tox-bootstrapd',
        ROOT_DIR,
      ).freeze

      attr_reader :config_file_path, :stdout_lines, :stderr_lines

      def initialize(config_file_path)
        self.config_file_path = config_file_path
        start_process
        @stdout_lines = [].freeze
        @stderr_lines = [].freeze
        stdout_poll_thread
        stderr_poll_thread
      end

      def close
        ::Process.kill :SIGKILL, @wait_thr.pid
        nil
      end

    private

      def config_file_path=(value)
        @config_file_path = value.frozen? ? value : value.dup.freeze
      end

      def start_process
        _stdin, @stdout, @stderr, @wait_thr = Open3.popen3(
          WRAPPER_FILE_PATH,
          DAEMON_FILE_PATH,
          '--foreground',
          '--log-backend',
          'stdout',
          '--config',
          config_file_path,
        )
      end

      def stdout_poll_thread
        @stdout_poll_thread ||= Thread.start do
          until @stdout.eof?
            begin
              @stdout_lines = [*@stdout_lines, @stdout.readline.freeze].freeze
            rescue EOFError
              IO.select [@stdout]
            end
          end
        end
      end

      def stderr_poll_thread
        @stderr_poll_thread ||= Thread.start do
          until @stderr.eof?
            begin
              @stderr_lines = [*@stderr_lines, @stderr.readline.freeze].freeze
            rescue EOFError
              IO.select [@stderr]
            end
          end
        end
      end
    end
  end
end
