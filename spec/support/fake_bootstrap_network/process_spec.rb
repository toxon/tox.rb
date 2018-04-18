# frozen_string_literal: true

require 'support/fake_bootstrap_network/process'
require 'support/fake_bootstrap_network/config'

RSpec.describe Support::FakeBootstrapNetwork::Process do
  subject { described_class.new config_file_path }

  let(:tmpdir) { Dir.mktmpdir('tox-').freeze }

  let(:config_file_path) { File.join(tmpdir, 'config').freeze }
  let(:keys_file_path)   { File.join(tmpdir, 'keys').freeze   }
  let(:pid_file_path)    { File.join(tmpdir, 'pid').freeze    }

  let(:port) { random_port }

  let :config do
    Support::FakeBootstrapNetwork::Config.new(
      keys_file_path: keys_file_path,
      pid_file_path: pid_file_path,
      port: port,
      enable_ipv6: false,
      enable_ipv4_fallback: true,
      enable_lan_discovery: false,
      enable_tcp_relay: false,
      tcp_relay_ports: [],
      enable_motd: false,
      motd: '',
      bootstrap_nodes: [],
    )
  end

  before do
    File.write config_file_path, config.render
  end

  after do
    FileUtils.rm_rf tmpdir
  end

  describe '#stdout_lines' do
    before do
      begin
        Timeout.timeout 2 do
          sleep 0.01 while subject.stdout_lines.empty?
        end
      rescue Timeout::Error
        nil
      end
    end

    specify do
      expect(subject.stdout_lines).to be_instance_of Array
    end

    specify do
      expect(subject.stdout_lines).to be_frozen
    end

    specify do
      expect(subject.stdout_lines).not_to be_empty
    end

    it 'chomps lines' do
      expect(subject.stdout_lines).not_to grep(/\n/)
    end

    it 'contains version' do
      expect(subject.stdout_lines).to \
        grep(/^Running "tox-bootstrapd" version \d+\.$/)
    end

    it 'contains public key' do
      begin
        Timeout.timeout 2 do
          sleep 0.01 while subject.stdout_lines.grep(/^Public Key:/).empty?
        end
      rescue Timeout::Error
        nil
      end

      expect(subject.stdout_lines).to \
        grep(/^Public Key: [0-9A-Z]{#{2 * Tox::PublicKey.bytesize}}$/)
    end
  end

  describe '#stderr_lines' do
    before do
      begin
        Timeout.timeout 2 do
          sleep 0.01 while subject.stderr_lines.empty?
        end
      rescue Timeout::Error
        nil
      end
    end

    specify do
      expect(subject.stderr_lines).to be_instance_of Array
    end

    specify do
      expect(subject.stderr_lines).to be_frozen
    end

    it 'chomps lines' do
      expect(subject.stderr_lines).not_to grep(/\n/)
    end
  end
end
