# frozen_string_literal: true

module Tox
  ##
  # Ruby core classes extensions.
  #
  module CoreExt
    refine Module do
      def ancestor_of!(value)
        return if value.is_a? self
        raise TypeError, "Expected #{self}, got #{value.class}"
      end
    end
  end
end
