class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Devise permits only email and password by default, so the profile fields
  # would be dropped silently on both sign-up and account update — the form
  # would submit, the record would save, and the values would simply not be
  # there.
  PROFILE_FIELDS = %i[ name address mobile_number interests ].freeze

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: PROFILE_FIELDS)
    devise_parameter_sanitizer.permit(:account_update, keys: PROFILE_FIELDS)
  end
end
