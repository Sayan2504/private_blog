class DashboardController < ApplicationController
  def show
    published_posts = Post.published.to_a

    @published_count = published_posts.size
    @draft_count = Post.drafts.count
    @total_views = Post.sum(:views_count)
    @avg_reading_time = published_posts.any? ? (published_posts.sum(&:reading_time) / published_posts.size.to_f).round(1) : 0
    @trending_posts = Post.published.order(views_count: :desc).limit(5)
    @posts = Post.published
  end
end
