module Findout
  module Node
    class Base
      attr_accessor :parent, :children

      def initialize(*args)
        @children = []
      end

      def attributes=(attrs = {})
        attrs.each do |key, val|
          send("#{key}=", val)
        end
      end

      def descendants
        nodes = [self]
        children.each { |c| nodes += c.descendants }
        nodes
      end

      def add_child(node)
        node.parent = self
        children << node
        node
      end

      def leaf?
        children.empty?
      end

      def root?
        self.class == Node::Root
      end

      def logic?
        self.class == Node::Logic
      end

      def operation?
        self.class == Node::Operation
      end

      def attribute?
        self.class == Node::Attribute
      end

      def value?
        self.class == Node::Value
      end
    end
  end
end
