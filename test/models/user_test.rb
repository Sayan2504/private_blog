require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "interests typed as one comma-separated line become a real list" do
    user = users(:two)

    user.interests = "ruby, rails , ruby,  , hiking"

    # Trimmed, de-duplicated, and blanks dropped — a trailing comma or a double
    # space is a typing artefact, not an interest.
    assert_equal [ "ruby", "rails", "hiking" ], user.interests
  end

  test "interests survive being handed back as an array" do
    user = users(:two)

    user.interests = [ "ruby", "rails" ]

    assert_equal [ "ruby", "rails" ], user.interests
  end

  test "interests_text round-trips into the form field" do
    assert_equal "fiction, distributed systems, cycling", users(:one).interests_text
  end

  test "a name is required" do
    user = User.new(email: "x@example.com", password: "password123")

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "display_name falls back for accounts made before names were collected" do
    user = User.new(email: "early.adopter@example.com")

    assert_equal "early.adopter", user.display_name
  end

  test "mobile numbers are accepted in the shapes people actually write them" do
    [ "+91 98765 43210", "9876543210", "+1 (555) 014-8000", "020-7946-0018" ].each do |number|
      user = User.new(email: "x@example.com", password: "password123", name: "A", mobile_number: number)
      user.valid?

      assert_empty user.errors[:mobile_number], "expected #{number.inspect} to be accepted"
    end
  end

  test "a mobile number that is plainly not one is rejected" do
    user = User.new(email: "x@example.com", password: "password123", name: "A", mobile_number: "call me")
    user.valid?

    assert_includes user.errors[:mobile_number], "should look like a phone number"
  end
end
