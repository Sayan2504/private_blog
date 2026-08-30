require "application_system_test_case"

# The app's replacement for window.confirm. Turbo routes every
# `data-turbo-confirm` through it, so these cover the contract the whole app
# depends on rather than one button's behaviour.
class ConfirmDialogTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
    sign_in_as(users(:one))
  end

  test "a destructive action opens the app's dialog, not the browser's" do
    visit post_url(@post)
    click_on "Delete"

    within_dialog do
      assert_text "Delete this story?"
      assert_text "It cannot be undone."
      assert_selector "button", text: "Delete story"
      assert_selector "button", text: "Cancel"
    end
  end

  test "cancelling leaves the record alone" do
    visit post_url(@post)
    click_on "Delete"
    dismiss_dialog

    assert_no_selector "dialog[open]"
    assert_text @post.title
    assert Post.exists?(@post.id), "cancelling a delete must not delete anything"
  end

  test "escape dismisses it and confirms nothing" do
    visit post_url(@post)
    click_on "Delete"
    assert_selector "dialog[open]"

    page.send_keys :escape

    assert_no_selector "dialog[open]"
    assert Post.exists?(@post.id)
  end

  # Focus must not start on the destructive button, or Enter becomes a
  # shortcut for deleting something.
  test "focus opens on Cancel, not on the action being confirmed" do
    visit post_url(@post)
    click_on "Delete"

    assert_equal "Cancel", page.evaluate_script("document.activeElement.textContent.trim()")
  end

  # The dialog agrees with the button that opened it: a reversible action does
  # not get the red treatment reserved for the ones that are not.
  test "a reversible action is not dressed as a destructive one" do
    visit edit_post_url(@post)
    click_on "Unpublish"

    within_dialog do
      assert_text "Move this story back to drafts?"
      assert_selector "button", text: "Unpublish"
      assert_no_selector "button", text: "Delete story"
    end
  end

  # The one path that does not go through a real form. Turbo synthesises a form
  # from a link carrying `data-turbo-method` and asks for confirmation with
  # *that* form, which is built from the attributes Turbo knows about — the
  # title, label and variant are not among them. If the dialog still shows the
  # card's own copy, the controller found the clicked link.
  test "a card's delete link keeps its copy through Turbo's form synthesis" do
    visit mine_posts_url

    find("a[aria-label='Delete #{@post.title}']").click

    within_dialog do
      assert_text "Delete this story?"
      assert_selector "button", text: "Delete story"
    end
  end

  test "the account deletion carries its own copy" do
    visit edit_user_registration_url
    scroll_into_view("button", text: "Delete account")
    click_on "Delete account"

    within_dialog do
      assert_text "Delete your account?"
      assert_selector "button", text: "Delete account"
    end
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
