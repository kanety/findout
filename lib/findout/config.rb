require 'active_support/core_ext/class/attribute'

module Findout
  class Config
    class_attribute :options, default: {
      query_key: { where: :q, order: :s },
      association_separator: '.',
      sort_class: { asc: 'sort-asc', desc: 'sort-desc' }
    }

    options.keys.each do |key|
      define_singleton_method "#{key}" do
        options[key]
      end

      define_singleton_method "#{key}=" do |val|
        options[key] = val
      end
    end

    class << self
      def configure
        yield self
      end
    end
  end
end
