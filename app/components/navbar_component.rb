# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  def initialize(current_path: "/")
    @current_path = current_path
  end
end
