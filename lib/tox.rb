# frozen_string_literal: true

require 'tox/version'
require 'tox/tox'

##
# libtoxcore for Ruby.
#
class Tox
  def initialize(options = Tox::Options.new)
    initialize_with options
  end
end
