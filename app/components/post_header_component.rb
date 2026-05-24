# frozen_string_literal: true

class PostHeaderComponent < ViewComponent::Base
  def initialize(post:)
    @post = post
  end

  private

  attr_reader :post
end
