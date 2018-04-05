# frozen_string_literal: true

RSpec.describe 'Two clients' do
  let! :node_pid do
    Process.spawn(
      node_executable,
      '--foreground',
      '--log-backend', 'stdout',
      '--config', node_config,
    )
  end

  after do
    Process.kill :SIGINT, node_pid
  end

  let(:node_config) { File.expand_path 'config/node.conf' }

  let :node_executable do
    if File.executable? node_vendored
      node_vendored
    elsif File.executable? node_local
      node_local
    else
      raise "Executable not found at #{node_vendored} and #{node_local}"
    end
  end

  let(:node_vendored) { File.expand_path 'vendor/libtoxcore/tox-bootstrapd' }
  let(:node_local) { '/usr/local/src/c-toxcore/_build/tox-bootstrapd' }

  specify do
    node_public_key =
      'A8020928C0B6AE8665A532C1084D1344CCC96724670122A1CB879E36F85A7D60'

    node = Tox::Node.new(
      ipv4: '127.0.0.1',
      port: 33_445,
      public_key: node_public_key,
    )

    options = Tox::Options.new
    # FIXME: use bootstrap node instead of local discovery
    options.local_discovery_enabled = true

    send_queue = Queue.new
    recv_queue = Queue.new

    send_client = Tox::Client.new options
    recv_client = Tox::Client.new options

    send_client.friend_add_norequest recv_client.public_key
    recv_client.friend_add_norequest send_client.public_key

    sleep 0.1 until send_client.friends.last.exist?
    sleep 0.1 until recv_client.friends.last.exist?

    expect(send_client.bootstrap(node)).to eq true
    expect(recv_client.bootstrap(node)).to eq true

    send_client.on_iteration do
      send_queue.size.times do
        text = send_queue.pop true
        begin
          send_client.friends.last.exist!.send_message text
        rescue Tox::Friend::NotConnectedError
          send_queue << text
        end
      end
    end

    recv_client.on_friend_message do |_friend, text|
      recv_queue << text
    end

    send_thread = Thread.start do
      send_client.run
    end

    recv_thread = Thread.start do
      recv_client.run
    end

    sleep 0.1 until send_client.running?
    sleep 0.1 until recv_client.running?

    send_data = %w[foo bar car].freeze

    send_data.each do |text|
      send_queue << text
    end

    begin
      Timeout.timeout 60 do
        sleep 1 while recv_queue.size < send_data.size
      end

      recv_data = Set.new

      recv_queue.size.times do
        recv_data << recv_queue.pop(true)
      end

      expect(recv_data).to eq send_data.to_set
    ensure
      send_client.stop
      recv_client.stop

      send_thread.join
      recv_thread.join
    end
  end
end
