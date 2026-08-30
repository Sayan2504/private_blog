require "test_helper"

class PostTest < ActiveSupport::TestCase
  # Two posts sharing a title is ordinary — the old behaviour turned it into a
  # validation error naming `slug`, a field that appears nowhere in the form.
  test "a duplicate title gets a numbered slug rather than an error" do
    first = create_post(title: "Notes")
    second = create_post(title: "Notes")
    third = create_post(title: "Notes")

    assert_equal "notes", first.slug
    assert_equal "notes-2", second.slug
    assert_equal "notes-3", third.slug
  end

  test "a title with nothing sluggable in it still saves" do
    post = create_post(title: "!!!")

    assert_predicate post, :persisted?
    assert_equal "post", post.slug
  end

  test "retitling a saved post leaves its slug, and its URL, alone" do
    post = create_post(title: "First name")

    post.update!(title: "Second name")

    assert_equal "first-name", post.slug
  end

  private

  def create_post(title:)
    Post.create!(title: title, user: users(:one))
  end
end
