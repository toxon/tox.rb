# frozen_string_literal: true

module Tox
  module Status
    ##
    # Tox network status from the official website.
    #
    class Official < JsonApiRequest
      # JSON API endpoint of the official network status server.
      URL = 'https://nodes.tox.chat/json'

      def initialize
        super URL
      end
    end
  end
end
