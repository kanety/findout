module Findout
  class Shorthand
    def initialize(base)
      @base = base
    end

    def find(src)
      matched = longest_match(src.to_s.split('_'))
      if matched && matched.size > 1 && matched.join('_') == src.to_s
        matched.map(&:to_sym)
      else
        nil
      end
    end

    private

    def longest_match(keys)
      (0..(keys.size - 1)).each do |n|
        key = keys[0..-n-1].join('_')
        if node?(key) || alternate?(key)
          keys.slice!(0, keys.size - n)
          return [key] + longest_match(keys).to_a
        end
      end
      return nil
    end

    def node?(key)
      Node.attribute?(@base, key) ||
        Node.operation?(key) ||
        Node.logic?(key)
    end

    def alternate?(key)
      key.respond_to?(:to_sym) && @base.class.alternates.key?(key.to_sym)
    end
  end
end
