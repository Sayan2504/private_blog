class AccountsController < ApplicationController
  before_action :authenticate_user!

  # Read-only: the account page shows what we hold about you and hands editing
  # off to Devise's registration form, rather than being a second place that
  # can write to the same record.
  def show
    @user = current_user
    @published_count = @user.posts.published.count
    @draft_count = @user.posts.drafts.count
  end
end
