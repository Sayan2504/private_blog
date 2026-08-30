require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  test "signing up captures the profile and the account page shows it back" do
    visit new_user_registration_url

    fill_in "Name", with: "Katherine Johnson"
    fill_in "Mobile number", with: "+1 555 0148"
    fill_in "Address", with: "Hampton, Virginia"
    fill_in "Interests", with: "orbital mechanics, mathematics"
    fill_in "Email", with: "katherine@example.com"
    fill_in "Password", with: "password123"
    fill_in "Confirm password", with: "password123"
    click_on "Create account"

    assert_selector "button", text: "Sign out"

    click_on "My account"

    assert_selector "h1", text: "Your details"
    assert_selector "h2", text: "Katherine Johnson"
    assert_text "katherine@example.com"
    assert_text "+1 555 0148"
    assert_text "Hampton, Virginia"
    assert_selector "span", text: "orbital mechanics"
    assert_selector "span", text: "mathematics"
  end

  test "editing details from the account page writes them back" do
    sign_in_as(users(:one))

    visit account_url
    click_on "Edit details"

    fill_in "Interests", with: "poetry, engines"
    fill_in "Current password", with: "password123"
    click_on "Save changes"

    assert_selector "span", text: "poetry"
    assert_selector "span", text: "engines"
    assert_no_selector "span", text: "cycling"
  end

  test "My account is not offered to signed-out readers" do
    visit root_url

    assert_no_link "My account"
  end

  private

  def sign_in_as(user)
    visit new_user_session_url
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Sign in"
    assert_selector "button", text: "Sign out"
  end
end
