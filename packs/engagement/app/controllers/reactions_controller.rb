class ReactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by_slug_or_id!(params.expect(:post_id))

    ActiveRecord::Base.transaction do
      reaction = current_user.reactions.find_or_initialize_by(post: @post)
      if reaction.new_record?
        reaction.save!
      else
        reaction.increment!(:count)
      end
      Post.increment_counter(:reactions_count, @post.id)
    end

    @post.reload

    Notification.notify!(
      recipient: @post.user,
      actor: current_user,
      notifiable: @post,
      action: "applauded"
    )
    Turbo::StreamsChannel.broadcast_update_to(
      @post,
      target: ActionView::RecordIdentifier.dom_id(@post, :reaction_count),
      html: @post.reactions_count.to_s
    )

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post }
    end
  end
end

