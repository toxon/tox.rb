# frozen_string_literal: true

module Tox
  module Status
    ##
    # Tox network status from the official website.
    #
    class Official < JsonApi
      # JSON API endpoint of the official network status server.
      URL = 'https://nodes.tox.chat/json'

      def initialize
        @data = JSON.parse Net::HTTP.get URI.parse URL
      end

    private

      attr_reader :data
    end
  end
end
