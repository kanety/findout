module Findout
  module Node
    class Attribute < Base
      attr_accessor :model, :name, :assoc

      def initialize(model, name, attrs = {})
        super
        model, name, assoc = Util.find_assoc(model, name)
        self.attributes = attrs.merge(model: model, name: name, assoc: assoc)
      end

      def arel
        model.arel_table[name]
      end
    end
  end
end
