module Findout
  class Compiler
    def initialize(base)
      @base = base
    end

    def run(root)
      compile(root)
    end

    private

    def compile(node)
      if node.root?
        compile_root(node)
      elsif node.logic?
        compile_logic(node)
      elsif node.attribute?
        compile_attribute(node)
      end
    end

    def compile_root(node)
      node.children.map { |c| compile(c) }.compact.flatten
    end

    def compile_logic(node)
      compiled = node.children.flat_map { |c| compile(c) }
      if node.operator == :not
        compiled.reduce(:and).send(node.operator)
      else
        compiled.reduce(node.operator)
      end
    end

    def compile_attribute(attribute)
      arel = attribute_to_arel(attribute)
      if attribute.children.size == 0
        [arel]
      else
        attribute.children.flat_map do |child|
          if child.operation?
            compile_operation(arel, child)
          end
        end
      end
    end

    def attribute_to_arel(attribute)
      attribute.arel
    end

    def compile_operation(arel, operation)
      if operation.children.size == 0
        operation_to_arel(arel, operation)
      else
        operation.children.inject(arel) do |arel, value|
          operation_to_arel(arel, operation, value)
        end
      end
    end

    def operation_to_arel(arel, operation, value = nil)
      if value
        arel.send(operation.operator, value.val)
      else
        arel.send(operation.operator)
      end
    end
  end
end
