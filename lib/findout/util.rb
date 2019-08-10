module Findout
  class Util
    class << self
      def find_model(base_klass)
        base_klass.name.gsub(/Finder$/, '').singularize.constantize
      end

      def find_assoc(base_model, name)
        names = name.to_s.split(Config.association_separator)
        model = names[0..-2].inject(base_model) { |m, assoc| m&.reflect_on_association(assoc)&.klass }
        if model && model.column_names.include?(names.last)
          assoc = names[0..-2].reverse.inject({}) { |ret, assoc| { assoc => ret } }
          [model, names.last, assoc]
        else
          nil
        end
      end

      def to_hash(params)
        case params
        when Array
          params.map { |param| to_hash(param) }
        when Hash
          params.deep_symbolize_keys
        when ActionController::Parameters
          params.to_hash.deep_symbolize_keys
        else
          params
        end
      end
    end
  end
end
