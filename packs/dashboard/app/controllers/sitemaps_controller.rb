class SitemapsController < ApplicationController
  def show
    @posts = Post.published.select(:id, :slug, :updated_at)
    @authors = User.joins(:posts).where.not(posts: { published_at: nil }).distinct.select(:id, :updated_at)

    respond_to do |format|
      format.xml
    end
  end
end

