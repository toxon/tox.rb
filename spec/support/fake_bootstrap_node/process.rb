# frozen_string_literal: true

require 'open3'

module Support
  module FakeBootstrapNode
    class Process
      ROOT_DIR = File.expand_path('../../..', __dir__).freeze

      DAEMON_FILE_PATH = File.expand_path(
        'vendor/bin/tox-bootstrapd',
        ROOT_DIR,
      ).freeze

      attr_reader :config_file_path

      def initialize(config_file_path)
        self.config_file_path = config_file_path

        _stdin, @stdout, @wait_thr = Open3.popen2(
          DAEMON_FILE_PATH,
          '--foreground',
          '--log-backend',
          'stdout',
          '--config',
          self.config_file_path,
        )
      end

    private

      def config_file_path=(value)
        @config_file_path = value.frozen? ? value : value.dup.freeze
      end
    end
  end
end
