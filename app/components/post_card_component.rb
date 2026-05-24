# frozen_string_literal: true

class PostCardComponent < ViewComponent::Base
  def initialize(post:)
    @post = post
  end

  private

  attr_reader :post
end
