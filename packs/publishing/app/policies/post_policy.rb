class PostPolicy
  def initialize(user, post)
    @user = user
    @post = post
  end

  def show?
    @post.published? || owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def owner?
    @user.present? && @post.user_id == @user.id
  end
end
