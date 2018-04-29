# frozen_string_literal: true

module Tox
  ##
  # Tox network status received from server running https://github.com/Tox/ToxStatus
  #
  class Status
    using CoreExt

    # JSON API endpoint of the official network status server.
    OFFICIAL_URL = 'https://nodes.tox.chat/json'

    attr_reader :url

    inspect_keys :last_refresh, :last_scan

    def initialize(url = OFFICIAL_URL)
      self.url = url
    end

    def last_refresh
      @last_refresh ||= Time.at(data['last_refresh']).utc.freeze
    end

    def last_scan
      @last_scan ||= Time.at(data['last_scan']).utc.freeze
    end

    def all_nodes
      @all_nodes ||= data['nodes'].map { |node_data| Node.new node_data }.freeze
    end

    def udp_nodes
      @udp_nodes ||= all_nodes.select(&:status_udp).freeze
    end

    def tcp_nodes
      @tcp_nodes ||= all_nodes.select(&:status_tcp).freeze
    end

  private

    def url=(value)
      @url = value.dup_and_freeze
    end

    def data
      @data ||= JSON.parse Net::HTTP.get URI.parse url
    end
  end
end
