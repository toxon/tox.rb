# frozen_string_literal: true

module Tox
  ##
  # Ruby core classes extensions.
  #
  module CoreExt
    refine Object do
      def dup_and_freeze
        frozen? ? self : dup.freeze
      end
    end

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

        eigenclass.send :define_method, method_name do |*|
          raise NotImplementedError, "#{self}.#{method_name}"
        end
      end
    end

    refine Class do
      def inspect_string(&block)
        define_method :inspect do
          "#<#{self.class}:#{instance_eval(&block)}>"
        end
      end

      def inspect_keys(*method_names)
        define_method :inspect do
          s = method_names.map do |method_name|
            "#{method_name}: #{send(method_name).inspect}"
          end.join(', ')

          "#<#{self.class} #{s}>"
        end
      end
    end
  end
end
