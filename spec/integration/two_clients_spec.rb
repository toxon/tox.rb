# frozen_string_literal: true

RSpec.describe 'Two clients' do
  let! :node_pids do
    node_configs.map do |node_config|
      Process.spawn(
        node_executable,
        '--foreground',
        '--log-backend',
        'stdout',
        '--config',
        node_config,
      )
    end
  end

  after do
    node_pids.each do |node_pid|
      Process.kill :SIGINT, node_pid
    end
  end

  let :node_executable do
    node_vendored
    # if File.executable? node_vendored
    #   node_vendored
    # elsif File.executable? node_local
    #   node_local
    # else
    #   raise "Executable not found at #{node_vendored} and #{node_local}"
    # end
  end

  let(:node_vendored) { File.expand_path 'vendor/libtoxcore/build/tox-bootstrapd' }
  let(:node_local) { '/usr/local/src/c-toxcore/_build/tox-bootstrapd' }

  let :node_configs do
    [
      File.expand_path('config/node1_conf'),
      File.expand_path('config/node2_conf'),
      File.expand_path('config/node3_conf'),
    ]
  end

  let :nodes do
    [
      Tox::Node.new(
        ipv4: '127.0.0.1',
        port: 10_100,
        public_key: 'A8020928C0B6AE8665A532C1084D1344' \
                    'CCC96724670122A1CB879E36F85A7D60',
      ),
      Tox::Node.new(
        ipv4: '127.0.0.1',
        port: 10_200,
        public_key: '88A8100DEEDE5223603231768C64BDF0' \
                    '27667C0ADC58ED006DED26D1881E1122',
      ),
      Tox::Node.new(
        ipv4: '127.0.0.1',
        port: 10_300,
        public_key: '89D8F36C2201371B9B3CD3EE7EC8E834' \
                    '319FEE8014E02F949BDD2DE7E5E5167D',
      ),
    ]
  end

  specify do
    options = Tox::Options.new
    options.local_discovery_enabled = false

    send_queue = Queue.new
    recv_queue = Queue.new

    send_client = Tox::Client.new options
    recv_client = Tox::Client.new options

    send_client.friend_add_norequest recv_client.public_key
    recv_client.friend_add_norequest send_client.public_key

    sleep 0.1 until send_client.friends.last.exist?
    sleep 0.1 until recv_client.friends.last.exist?

    nodes.each do |node|
      expect(send_client.bootstrap(node)).to eq true
      expect(recv_client.bootstrap(node)).to eq true
    end

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
