# frozen_string_literal: true

module Tox
  module Status
    ##
    # Base class for Tox network status.
    #
    class Base
      def inspect
        @inspect ||= "#<#{self.class} last_refresh: #{last_refresh}, last_scan: #{last_scan}>"
      end

      def last_refresh
        raise NotImplementedError, "#{self.class}#last_refresh"
      end

      def last_scan
        raise NotImplementedError, "#{self.class}#last_scan"
      end

      def nodes
        raise NotImplementedError, "#{self.class}#nodes"
      end
    end
  end
end
