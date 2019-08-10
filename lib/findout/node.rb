require_relative 'node/base'
require_relative 'node/root'
require_relative 'node/logic'
require_relative 'node/operation'
require_relative 'node/attribute'
require_relative 'node/value'

module Findout
  module Node
    class << self
      def logic?(key)
        key.respond_to?(:to_sym) && Node::Logic.operators.include?(key.to_sym)
      end

      def operation?(key)
        key.respond_to?(:to_sym) && Node::Operation.operators.include?(key.to_sym)
      end

      def attribute?(base, key)
        key.respond_to?(:to_sym) && Util.find_assoc(base.model, key)
      end
    end
  end
end
