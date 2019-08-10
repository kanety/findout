module Findout
  class Preprocessor
    def initialize(base)
      @base = base
    end

    def run(params)
      process(params)
    end

    private

    def process(params)
      if params.is_a?(Array)
        process_array(params)
      elsif params.is_a?(Hash)
        process_hash(params)
      else
        process_value(params)
      end
    end

    def process_array(array)
      array.map do |a|
        process(a)
      end
    end

    def process_hash(hash)
      remove_empty(hash)
      convert_flat_format(hash)

      hash.map do |key, val|
        if keys = find_alternates(key)
          process_hash(resolve_alternates(keys, val))
        elsif keys = find_shorthand(key)
          process_hash(resolve_shorthand(keys, val))
        elsif val.is_a?(Array) && val.all? { |v| v.is_a?(Hash) }
          { key => process_array(val) }
        elsif val.is_a?(Hash)
          { key => process_hash(val) }
        elsif val.is_a?(Symbol)
          { key => process_value(val) }
        else
          { key => val }
        end
      end.reduce(:deep_merge)
    end

    def process_value(val)
      if (vals = find_alternates(val))
        process(vals)
      elsif (vals = find_shorthand(val))
        last = vals.pop
        process_hash(resolve_shorthand(vals, last))
      else
        val
      end
    end

    def remove_empty(hash)
      hash.keys.each do |key|
        val = hash[key]
        hash.delete(key) if val.nil? || (val.respond_to?(:empty?) && val.empty?)
      end
    end

    def convert_flat_format(hash)
      if hash[:col].respond_to?(:to_sym) && hash[:ope].respond_to?(:to_sym) && hash[:val]
        col = hash.delete(:col)
        ope = hash.delete(:ope)
        val = hash.delete(:val)
        hash[col.to_sym] = { ope.to_sym => val }
      end
    end

    def find_alternates(key)
      key.respond_to?(:to_sym) && @base.class.alternates[key.to_sym]
    end

    def resolve_alternates(keys, val)
      Array(keys).map { |key| { key.to_sym  => val } }.reduce(:deep_merge)
    end

    def find_shorthand(key)
      if key.is_a?(Symbol) || key.is_a?(String)
        Shorthand.new(@base).find(key)
      else
        nil
      end
    end

    def resolve_shorthand(keys, val)
      keys = Array(keys)
      keys.reverse.inject(val) { |ret, k| { k => ret } }
    end
  end
end
