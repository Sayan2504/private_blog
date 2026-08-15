# frozen_string_literal: true

class PostCardComponent < ViewComponent::Base
  def initialize(post:, current_user: nil)
    @post = post
    @current_user = current_user
  end

  private

  attr_reader :post, :current_user

  def owner?
    current_user.present? && post.user_id == current_user.id
  end
end
