# frozen_string_literal: true

require 'support/fake_bootstrap_network/instance'

module Support
  module FakeBootstrapNetwork
    extend RSpec::SharedContext

    let :bootstrap_nodes do
      [
        Instance.new(port: rand(1024..65_535)),
        Instance.new(port: rand(1024..65_535)),
        Instance.new(port: rand(1024..65_535)),
      ].freeze
    end

    before do
      bootstrap_nodes.each do |instance|
        instance.start(
          bootstrap_nodes.map do |node|
            {
              address: '127.0.0.1',
              port: node.port,
              public_key: node.public_key.to_s,
            }
          end,
        )
      end
    end

    after do
      bootstrap_nodes.each(&:stop)
    end
  end
end
