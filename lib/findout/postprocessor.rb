module Findout
  class Postprocessor
    def initialize(base)
      @base = base
    end

    def run(root)
      visit(root)
    end

    private

    def visit(node)
      if node.operation?
        replace_operation(node)
      end

      node.children.each do |child|
        if child.attribute? && missing_operation?(child)
          insert_operation(child)
        end
        visit(child)
      end
    end

    def missing_operation?(attribute)
      children = attribute.children
      children.size > 0 && children.all? { |c| c.leaf? && c.value? }
    end

    def insert_operation(attribute)
      attribute.children.each_with_index do |child, i|
        operator = child.val.is_a?(Array) ? :in : :eq
        attribute.children[i] = Node::Operation.new(operator, children: [child])
      end
    end

    def replace_operation(operation)
      case operation.operator
      when :between, :not_between
        replace_between(operation)
      when :matches, :does_not_match,
           :matches_any, :matches_all, :does_not_match_any, :does_not_match_all
        replace_match(operation)
      when :word_all, :word_any
        replace_words(operation)
      end
    end

    def replace_between(operation)
      operation.children.each do |node|
        if node.value? && node.val.is_a?(Array) && node.val.size >= 2
          node.val = node.val.first..node.val.second
        end
      end
    end

    def replace_match(operation)
      operation.children.each do |node|
        if node.value?
          node.val = partial_match(node.val)
        end
      end
    end

    def replace_words(operation)
      map = {
        word_all: :matches_all,
        word_any: :matches_any
      }
      operation.operator = map[operation.operator]
      operation.children.each do |node|
        if node.value?
          node.val = partial_matches(node.val)
        end
      end
    end

    def partial_match(word)
      if word.is_a?(Array)
        word.map { |w| partial_match(w) }
      else
        "%#{escape(word)}%"
      end
    end

    def partial_matches(text)
      text.to_s.split(/[ 　]+/).map { |word| partial_match(word) }
    end

    def escape(s)
      if @base.model.connection.adapter_name.downcase == 'sqlite'
        s
      else
        s.to_s.gsub(/[\\%_]/) { |r| "\\#{r}" }
      end
    end
  end
end
