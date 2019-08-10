module Findout
  module Node
    class Logic < Base
      class_attribute :operators, default: [:and, :or, :not]

      attr_accessor :operator

      def initialize(operator, attrs = {})
        super
        self.attributes = attrs.merge(operator: operator)
      end
    end
  end
end
