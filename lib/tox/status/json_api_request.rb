# frozen_string_literal: true

module Tox
  module Status
    ##
    # Request Tox network status from https://github.com/Tox/ToxStatus
    #
    class JsonApiRequest < JsonApi
      attr_reader :url

      def initialize(url)
        self.url = url
        data
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
end
