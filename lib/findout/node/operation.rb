module Findout
  module Node
    class Operation < Base
      class_attribute :operators, default: [
        :eq, :not_eq, :eq_any, :eq_all, :not_eq_any, :not_eq_all,
        :lt, :lteq, :lt_any, :lt_all, :lteq_any, :lteq_all,
        :gt, :gteq, :gt_any, :gt_all, :gteq_any, :gteq_all,
        :in, :not_in, :in_any, :in_all, :not_in_any, :not_in_all,
        :between, :not_between,
        :matches, :does_not_match, :matches_any, :matches_all, :does_not_match_any, :does_not_match_all,
        :word_any, :word_all, :asc, :desc,
        :average, :maximum, :minimum, :sum, :count, :extract
      ]

      attr_accessor :operator

      def initialize(operator, attrs = {})
        super
        self.attributes = attrs.merge(operator: operator)
      end
    end
  end
end
