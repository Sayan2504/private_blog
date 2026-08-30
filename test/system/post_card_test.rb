require "application_system_test_case"

class PostCardTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
    sign_in_as(users(:one))
  end

  # The card lifts on hover and looks clickable everywhere, so it has to be.
  test "the whole card is the click target, not just the text block" do
    visit published_posts_url
    settle_cards

    card = find("article", text: @post.title, match: :first)

    # Away from the title and the action buttons — padding that used to be dead.
    card.click(x: 12, y: 12)

    assert_selector "h1", text: @post.title
  end

  # The link used to wrap the status, author, date, title and 160 characters
  # of excerpt, and announced all of it as one name.
  test "the card's link is named by its title alone" do
    visit published_posts_url

    assert_selector "a", exact_text: @post.title
  end

  test "the owner's actions sit above the card link and still work" do
    visit published_posts_url

    find("a[aria-label='Edit #{@post.title}']").click

    assert_selector "button", text: "Save changes"
  end

  private

  # The grid deals its cards out from a pile over ~940ms (see
  # reveal_controller.js), so their coordinates are still moving on arrival and
  # a click by position can land on a neighbour. The controller strips
  # data-reveal-item from each card once it has settled.
  def settle_cards
    assert_selector "article", minimum: 1
    assert_no_selector "article[data-reveal-item]", wait: 5
  end

  def sign_in_as(user)
    visit new_user_session_url
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Sign in"
    assert_selector "button", text: "Sign out"
  end
end
