require 'simplecov'
SimpleCov.start

require 'rails_helper'

def debug(finder)
  puts finder.relation.to_sql if ENV['DEBUG'].to_i >= 1
  pp finder.searcher.parsed if ENV['DEBUG'].to_i >= 2
  pp finder.searcher.compiled if ENV['DEBUG'].to_i >= 3
end
