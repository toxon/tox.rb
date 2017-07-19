# frozen_string_literal: true

module Tox
  module Status
    ##
    # Request Tox network status from https://github.com/Tox/ToxStatus
    #
    class JsonApiRequest < JsonApi
      def initialize(url)
        @data = JSON.parse Net::HTTP.get URI.parse url
      end

    private

      attr_reader :data
    end
  end
end
