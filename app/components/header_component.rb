# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(user_signed_in: false)
    @user_signed_in = user_signed_in
  end

  private

  attr_reader :user_signed_in
end
