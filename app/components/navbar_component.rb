# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def initialize(current_path: "/", user_signed_in: false)
    @current_path = current_path
    @user_signed_in = user_signed_in
  end

  private

  attr_reader :user_signed_in
end
