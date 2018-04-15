# frozen_string_literal: true

require 'support/fake_bootstrap_network/instance'

module Support
  module FakeBootstrapNetwork
    def bootstrap_nodes
      Support::FakeBootstrapNetwork.bootstrap_nodes
    end

    def self.bootstrap_nodes
      @bootstrap_nodes ||= [
        Instance.new(port: rand(1024..65_535)),
        Instance.new(port: rand(1024..65_535)),
        Instance.new(port: rand(1024..65_535)),
      ].freeze
    end

    def self.start_nodes
      bootstrap_nodes.map do |node|
        {
          address: '127.0.0.1',
          port: node.port,
          public_key: node.public_key.to_s,
        }
      end
    end

    def self.start
      bootstrap_nodes.each do |instance|
        instance.start start_nodes
      end
    end

    def self.stop
      bootstrap_nodes.each(&:stop)
    end
  end
end
