# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
      @url = value.frozen? ? value : value.dup.freeze
    end

    def data
      @data ||= JSON.parse Net::HTTP.get URI.parse url
    end
  end
end
