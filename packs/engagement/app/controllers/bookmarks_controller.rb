class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.bookmarked_posts.published.with_associations.order("bookmarks.created_at DESC")
  end

  def create
    @post = Post.find_by_slug_or_id!(params.expect(:post_id))
    bookmark = current_user.bookmarks.find_or_create_by!(post: @post)
    Notification.notify!(
      recipient: @post.user,
      actor: current_user,
      notifiable: bookmark,
      action: "bookmarked"
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @post, notice: "Saved to reading list." }
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find_by!(id: params.expect(:id))
    @post = bookmark.post
    bookmark.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: bookmarks_path, notice: "Removed from reading list.", status: :see_other }
    end
  end
end

