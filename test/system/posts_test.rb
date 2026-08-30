require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "visiting the public dashboard" do
    visit root_url
    assert_selector "h1", text: "MindCanvas, at a glance"
  end

  test "visiting published when signed in" do
    sign_in_as(users(:one))

    visit published_posts_url
    assert_selector "h1", text: "Everything published on MindCanvas"
  end

  test "should create post" do
    sign_in_as(users(:one))

    visit new_post_url
    fill_in "Title", with: "A brand new story"
    click_on "Save draft"

    assert_text "Post was successfully created"
  end

  test "should update Post" do
    sign_in_as(users(:one))

    visit edit_post_url(@post)
    fill_in "Title", with: "Updated title"
    click_on "Save changes"

    assert_text "Post was successfully updated"
  end

  test "editing a published story offers no button that claims to draft it" do
    sign_in_as(users(:one))

    visit edit_post_url(@post)

    assert_selector "button", text: "Save changes"
    assert_selector "button", text: "Unpublish"
    assert_no_selector "button", text: "Save draft"
  end

  test "should unpublish a published post back to drafts" do
    sign_in_as(users(:one))

    visit edit_post_url(@post)
    accept_confirm { click_on "Unpublish" }

    assert_text "Story moved back to drafts"
    assert_not_predicate @post.reload, :published?
  end

  test "should destroy Post" do
    sign_in_as(users(:one))

    visit post_url(@post)
    accept_confirm { click_on "Delete" }

    assert_text "Post was successfully destroyed"
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
