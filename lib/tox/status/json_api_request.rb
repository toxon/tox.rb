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
        @data = JSON.parse Net::HTTP.get URI.parse self.url
      end

    private

      attr_reader :data

      def url=(value)
        @url = value.frozen? ? value : value.dup.freeze
      end
    end
  end
end
