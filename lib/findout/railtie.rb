module Findout
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :action_view do
      require_relative 'helper'
      ActionView::Base.send :include, Helper
    end
  end
end
