class DashboardController < ApplicationController
  def show
    published_posts = Post.published.to_a

    @published_count = published_posts.size
    @total_views = Post.sum(:views_count)
    @avg_reading_time = published_posts.any? ? (published_posts.sum(&:reading_time) / published_posts.size.to_f).round(1) : 0
    @trending_posts = Post.published.order(views_count: :desc).limit(5)
    @posts = Post.published

    # Drafts are an authoring detail, and someone else's unpublished count is
    # none of a reader's business — so this is scoped to the signed-in user's
    # own drafts, and left nil entirely for signed-out visitors. The view
    # keys off nil to decide whether the tile exists at all.
    @draft_count = current_user.posts.drafts.count if user_signed_in?
  end
end
