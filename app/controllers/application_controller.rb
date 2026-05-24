class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  http_basic_authenticate_with name: ENV["BLOG_USER"], password: ENV["BLOG_PASSWORD"] if ENV["BLOG_USER"].present?
end
