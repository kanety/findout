require_relative 'parser'
require_relative 'compiler'

module Findout
  class Searcher
    attr_reader :relation, :parsed, :compiled

    def initialize(base)
      @base = base
      @relation = base.relation
    end

    def run(type, query)
      search!(type, query)
      @relation
    end

    private

    def search!(type, query)
      parsed = Parser.new(@base).run(query)
      return if parsed.nil?
      compiled = Compiler.new(@base).run(parsed)
      return if compiled.nil? || compiled.empty?

      @parsed = parsed
      @compiled = compiled

      build_joins(parsed)
      build_relations(type, compiled)
    end

    def build_joins(parsed)
      parsed.descendants.each do |node|
        if node.attribute? && !node.assoc.empty?
          @relation.joins!(node.assoc)
        end
      end
    end

    def build_relations(type, compiled)
      if compiled.is_a?(Array) && conditional_type?(type)
        compiled = compiled.reduce(:and)
      end
      @relation.send("#{type}!", compiled)
    end

    def conditional_type?(type)
      type == :where || type == :having
    end
  end
end
