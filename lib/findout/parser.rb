require_relative 'shorthand'
require_relative 'preprocessor'
require_relative 'postprocessor'
require_relative 'node'

module Findout
  class Parser
    def initialize(base)
      @base = base
    end

    def run(params)
      preprocessed = preprocess(params)
      parse(Node::Root.new, preprocessed).tap do |root|
        postprocess(root)
      end
    end

    private

    def preprocess(params)
      Preprocessor.new(@base).run(params)
    end

    def postprocess(root)
      Postprocessor.new(@base).run(root)
    end

    def parse(node, params)
      if params.is_a?(Array)
        parse_array(node, params)
      elsif params.is_a?(Hash)
        parse_hash(node, params)
      else
        parse_value(node, params)
      end
    end

    def parse_array(node, array)
      array.each do |q|
        parse(node, q)
      end
      node
    end

    def parse_hash(node, hash)
      hash.each do |key, val|
        parse_hash_value(parse_hash_key(node, key), val)
      end
      node
    end

    def parse_hash_key(node, key)
      if key.is_a?(Array) || key.is_a?(Hash)
        raise ParseError.new("Can't use array or hash as hash key: #{node.inspect}")
      else
        parse_value(node, key)
      end
    end

    def parse_hash_value(node, val)
      if val.is_a?(Hash)
        parse_hash(node, val)
      elsif val.is_a?(Array) && val.all? { |v| v.is_a?(Hash) }
        parse_array(node, val)
      else
        parse_value(node, val)
      end
    end

    def parse_value(node, key)
      if Node.logic?(key)
        node.add_child(Node::Logic.new(key))
      elsif Node.attribute?(@base, key)
        node.add_child(Node::Attribute.new(@base.model, key))
      elsif Node.operation?(key)
        node.add_child(Node::Operation.new(key))
      else
        node.add_child(Node::Value.new(key))
      end
    end
  end
end
