class DashboardController < ApplicationController
  def show
    published_posts = Post.published.with_associations.to_a

    @published_count = published_posts.size
    @total_views = published_posts.sum(&:views_count)
    @avg_reading_time = published_posts.any? ? (published_posts.sum(&:reading_time) / published_posts.size.to_f).round(1) : 0
    @trending_posts = published_posts.sort_by { |post| -post.views_count }.first(5)

    @feed = user_signed_in? && params[:feed] == "following" ? :following : :all
    @posts = if @feed == :following
      followed_ids = current_user.following.pluck(:id)
      published_posts.select { |post| followed_ids.include?(post.user_id) }
    else
      published_posts
    end

    @draft_count = current_user.posts.drafts.count if user_signed_in?
  end
end
