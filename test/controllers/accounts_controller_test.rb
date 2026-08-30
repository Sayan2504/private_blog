require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "the account page needs an account" do
    get account_url

    assert_redirected_to new_user_session_url
  end

  test "shows every profile field the app holds" do
    sign_in @user

    get account_url

    assert_response :success
    assert_select "h1", text: /Your details/i
    assert_select "body", text: /Ada Lovelace/
    assert_select "body", text: /user@example.com/
    assert_select "body", text: /\+91 98765 43210/
    assert_select "body", text: /Analytical Engine Lane/
  end

  test "renders interests as separate chips rather than one string" do
    sign_in @user

    get account_url

    assert_select "span", text: "fiction"
    assert_select "span", text: "distributed systems"
    assert_select "span", text: "cycling"
  end

  # The optional fields are still listed when blank — a missing row would leave
  # no way to tell "you didn't fill this in" from "we don't ask for this".
  test "states the blanks for a profile with only the required fields" do
    sign_in users(:two)

    get account_url

    assert_response :success
    assert_select "body", text: /Not added yet/
    assert_select "body", text: /Nothing listed yet/
  end

  test "counts the signed-in user's own work only" do
    sign_in @user

    get account_url

    assert_response :success
    assert_select "p", text: "Published"
    assert_select "p", text: "Drafts"
  end
end
