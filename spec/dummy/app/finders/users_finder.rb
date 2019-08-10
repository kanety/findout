class UsersFinder < ApplicationFinder
  alter :keyword, [:name, :title].map { |attr| "or_#{attr}_word_all" }
  alter :keyword_columns, [:name, :title]
  alter :created_at_updated_at, [:created_at, :updated_at]
  alter :updated_at_created_at, [:updated_at, :created_at]

  chain :name_param, :search_name
  chain :title_param, ->(value) { search_title(value) }

  def search_name(value)
    model.where(name: value) if value.present?
  end

  def search_title(value)
    model.where(title: value) if value.present?
  end
end
