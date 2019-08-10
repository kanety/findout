require_relative 'helper/sort_link'

module Findout
  module Helper
    def findout_sort_link(name, options = {}, html_options = {})
      key = Findout::Config.query_key[:order]
      sort = Util.to_hash(params)[key]
      options, html_options = SortLink.new(name, sort).build(options, html_options) if sort
      link_to name, params.merge(key => options), html_options
    end
  end
end
