# frozen_string_literal: true

module Tox
  ##
  # Tox network status from the official website.
  #
  class Status
    URL = 'https://nodes.tox.chat/json'

    def initialize
      @data = JSON.parse Net::HTTP.get URI.parse URL
    end

    def last_scan
      @last_scan ||= Time.at(@data['last_scan']).utc.freeze
    end

    def last_refresh
      @last_refresh ||= Time.at(@data['last_refresh']).utc.freeze
    end
  end
end
