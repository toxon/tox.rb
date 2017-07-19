# frozen_string_literal: true

module Tox
  module Status
    ##
    # Base class for Tox network status received from https://github.com/Tox/ToxStatus
    #
    class JsonApi < Base
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

      def data
        raise NotImplementedError, "#{self.class}#data"
      end
    end
  end
end
