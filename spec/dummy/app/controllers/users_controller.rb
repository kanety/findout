class UsersController < ActionController::Base
  layout 'application'

  def index
    permit_query
    @users = UsersFinder.search(params)
  end

  private

  def permit_query
    self.params = params.permit(
      :q => [:id, :created_at_gteq, :created_at_lteq, :created_at_day, :title_matches, :keyword],
      :s => [:id, :name, :title, :created_at_updated_at, :updated_at_created_at]
    )
  end
end
