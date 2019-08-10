require_relative 'searcher'
require_relative 'chainer'

module Findout
  module Base
    extend ActiveSupport::Concern

    included do
      class_attribute :_chains, default: {}
      class_attribute :_alternates, default: {}
      attr_reader :model, :relation, :params
      attr_reader :chainer, :searcher
    end

    def initialize(model: nil, relation: nil)
      @model = model || Util.find_model(self.class)
      @relation = relation || @model.all
    end

    def search(params = {})
      @params = Util.to_hash(params)
      @chainer = Chainer.new(self)
      @searcher = Searcher.new(self)

      Config.query_key.each do |type, key|
        @chainer.run(params[key])
        @searcher.run(type, params[key])
      end

      @relation
    end

    class_methods do
      def search(params = {}, options = {})
        new(options).search(params)
      end

      def chain(name, method)
        _chains.merge!(name  => method)
      end

      def chains
        _chains
      end

      def alter(before, after)
        _alternates.merge!(before => after)
      end

      def alternates
        _alternates
      end
    end
  end
end
