module Findout
  module Node
    class Value < Base
      attr_accessor :val

      def initialize(val, attrs = {})
        super
        self.attributes = attrs.merge(val: val)
      end
    end
  end
end
