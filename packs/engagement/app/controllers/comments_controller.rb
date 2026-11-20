class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      Notification.notify!(
        recipient: @post.user,
        actor: current_user,
        notifiable: @comment,
        action: "commented"
      )
      @comment.broadcast_append_to(@post, target: "comments-list", partial: "comments/comment", locals: { comment: @comment, broadcast: true })

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment posted." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create_error, status: :unprocessable_content }
        format.html { redirect_to @post, alert: @comment.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params.expect(:id))
    unless CommentPolicy.new(current_user, @comment).destroy?
      redirect_to @post, alert: "You can only delete your own comments."
      return
    end

    @comment.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "Comment deleted.", status: :see_other }
    end
  end

  private

  def set_post
    @post = Post.find_by_slug_or_id!(params.expect(:post_id))
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end

