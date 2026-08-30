module Users
  # Devise's own registration controller is kept, with one change: where it
  # sends you after a successful update.
  class RegistrationsController < Devise::RegistrationsController
    protected

    # Devise lands on the signed-in root — the dashboard — which is neither
    # where you came from nor where the change is visible. You edited your
    # details from the account page, so the account page, showing the new
    # values, is the answer to "did that work?".
    def after_update_path_for(_resource)
      account_path
    end
  end
end
