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

      def abstract_method(method_name)
        define_method method_name do |*|
          raise NotImplementedError, "#{self.class}##{method_name}"
        end
      end

      def abstract_class_method(method_name)
        eigenclass = class << self
          self
        end

        eigenclass.define_method method_name do |*|
          raise NotImplementedError, "#{self}.#{method_name}"
        end
      end
    end
  end
end
