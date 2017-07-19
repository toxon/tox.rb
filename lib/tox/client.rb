# frozen_string_literal: true

module Tox
  ##
  # Tox client.
  #
  class Client
    attr_accessor :running

    def initialize(options = Tox::Options.new)
      initialize_with options
    end

    def bootstrap_official
      Status.new.nodes.each do |node|
        bootstrap node
      end
    end
  end
end
