class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    @author = User.find(params.expect(:author_id))
    follow = current_user.active_follows.find_or_create_by!(followed: @author)

    Notification.notify!(
      recipient: @author,
      actor: current_user,
      notifiable: follow,
      action: "followed"
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to author_path(@author), notice: "Following #{@author.display_name}." }
    end
  end

  def destroy
    follow = current_user.active_follows.find(params.expect(:id))
    @author = follow.followed
    follow.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to author_path(@author), notice: "Unfollowed #{@author.display_name}.", status: :see_other }
    end
  end
end

