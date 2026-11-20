class AuthorsController < ApplicationController
  def show
    @author = User.find(params.expect(:id))
    @posts = @author.posts.published.with_associations
    @total_views = @posts.sum(:views_count)
  end
end

