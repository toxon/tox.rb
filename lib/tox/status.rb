# frozen_string_literal: true

module Tox
  ##
  # Tox network status received from server running https://github.com/Tox/ToxStatus
  #
  class Status
    # JSON API endpoint of the official network status server.
    OFFICIAL_URL = 'https://nodes.tox.chat/json'

    attr_reader :url

    def initialize(url = OFFICIAL_URL)
      self.url = url
    end

    def inspect
      @inspect ||= "#<#{self.class} last_refresh: #{last_refresh}, last_scan: #{last_scan}>"
    end

    def last_refresh
      @last_refresh ||= Time.at(data['last_refresh']).utc.freeze
    end

    def last_scan
      @last_scan ||= Time.at(data['last_scan']).utc.freeze
    end

    def nodes
      @nodes ||= data['nodes'].select { |node_data| node_data['status_udp'] }.map do |node_data|
        begin
          Node.new node_data['public_key'], node_data['port'], node_data['ipv4']
        rescue
          nil
        end
      end.compact.freeze
    end

  private

    def url=(value)
      @url = value.frozen? ? value : value.dup.freeze
    end

    def data
      @data ||= JSON.parse Net::HTTP.get URI.parse url
    end
  end
end
