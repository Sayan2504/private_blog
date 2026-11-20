class CommentPolicy
  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def destroy?
    return false if @user.blank?

    @comment.user_id == @user.id || @comment.post.user_id == @user.id
  end
end

