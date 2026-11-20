class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    if @query.present?
      @posts = Post.published.with_associations.search(@query).limit(6)
      @tags = Tag.where("name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query.downcase)}%").limit(5)
      @authors = User.where("name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%").limit(4)
    else
      @posts = Post.published.with_associations.limit(5)
      @tags = Tag.popular.limit(5)
      @authors = User.none
    end
  end
end

