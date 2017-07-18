# frozen_string_literal: true

module Tox
  ##
  # Tox network status from the official website.
  #
  class Status
    OFFICIAL_URL = 'https://nodes.tox.chat/json'

    def initialize(url = OFFICIAL_URL)
      @data = JSON.parse Net::HTTP.get URI.parse url
    end

    def inspect
      @inspect ||= "#<#{self.class} last_refresh: #{last_refresh}, last_scan: #{last_scan}>"
    end

    def last_refresh
      @last_refresh ||= Time.at(@data['last_refresh']).utc.freeze
    end

    def last_scan
      @last_scan ||= Time.at(@data['last_scan']).utc.freeze
    end

    def nodes
      @nodes ||= @data['nodes'].map do |node_data|
        begin
          Node.new node_data['public_key'], node_data['port'], node_data['ipv4']
        rescue
          nil
        end
      end.compact.freeze
    end
  end
end
