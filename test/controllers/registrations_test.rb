require "test_helper"

# Devise permits only email and password unless told otherwise, so without the
# sanitizer configuration in ApplicationController these fields would be
# dropped in silence: the form submits, the account is created, and the profile
# is simply empty.
class RegistrationsTest < ActionDispatch::IntegrationTest
  test "sign-up captures the whole profile, not just the credentials" do
    assert_difference("User.count", 1) do
      post user_registration_url, params: { user: {
        name: "Katherine Johnson",
        address: "Hampton, Virginia",
        mobile_number: "+1 555 0148",
        interests: "orbital mechanics, mathematics",
        email: "katherine@example.com",
        password: "password123",
        password_confirmation: "password123"
      } }
    end

    user = User.find_by(email: "katherine@example.com")
    assert_equal "Katherine Johnson", user.name
    assert_equal "Hampton, Virginia", user.address
    assert_equal "+1 555 0148", user.mobile_number
    assert_equal [ "orbital mechanics", "mathematics" ], user.interests
  end

  test "sign-up refuses an account with no name" do
    assert_no_difference("User.count") do
      post user_registration_url, params: { user: {
        name: "",
        email: "nameless@example.com",
        password: "password123",
        password_confirmation: "password123"
      } }
    end
  end

  test "the optional profile fields really are optional" do
    assert_difference("User.count", 1) do
      post user_registration_url, params: { user: {
        name: "Just A Name",
        email: "minimal@example.com",
        password: "password123",
        password_confirmation: "password123"
      } }
    end

    user = User.find_by(email: "minimal@example.com")
    assert_empty user.interests
    assert_nil user.mobile_number.presence
  end

  test "account update saves profile changes" do
    sign_in users(:one)

    patch user_registration_url, params: { user: {
      name: "Ada King",
      mobile_number: "+91 90000 00000",
      interests: "poetry, engines",
      address: "London",
      email: users(:one).email,
      current_password: "password123"
    } }

    user = users(:one).reload
    assert_equal "Ada King", user.name
    assert_equal [ "poetry", "engines" ], user.interests
    assert_equal "London", user.address
  end

  test "a mobile number that is not a number is rejected" do
    assert_no_difference("User.count") do
      post user_registration_url, params: { user: {
        name: "Typo Fingers",
        mobile_number: "call me maybe",
        email: "typo@example.com",
        password: "password123",
        password_confirmation: "password123"
      } }
    end
  end
end
