require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @draft = posts(:draft_one)
  end

  # --- The public archive -------------------------------------------------

  test "all stories is public, no authentication required" do
    get published_posts_url

    assert_response :success
    assert_select "h1", text: /Everything published on MindCanvas/i
  end

  test "all stories lists published posts from every author" do
    get published_posts_url

    assert_response :success
    assert_select "h2", text: posts(:one).title
    assert_select "h2", text: posts(:two).title
  end

  test "all stories never lists an unpublished post" do
    get published_posts_url

    assert_response :success
    assert_select "h2", text: @draft.title, count: 0
  end

  # --- Your own work ------------------------------------------------------

  test "should require authentication to view my stories" do
    get mine_posts_url

    assert_redirected_to new_user_session_path
  end

  test "my stories opens on the published tab, not the drafts" do
    sign_in users(:one)

    get mine_posts_url

    assert_response :success
    assert_select "h1", text: /Everything you've written/i
    assert_select "h2", text: @post.title
    assert_select "h2", text: @draft.title, count: 0
  end

  test "my stories drafts tab lists only unpublished work" do
    sign_in users(:one)

    get mine_posts_url(tab: "drafts")

    assert_response :success
    assert_select "h2", text: @draft.title
    assert_select "h2", text: @post.title, count: 0
  end

  # An unknown tab is a typed URL, not a state — it falls back to the default
  # rather than rendering an empty page.
  test "an unrecognised tab falls back to published" do
    sign_in users(:one)

    get mine_posts_url(tab: "nonsense")

    assert_response :success
    assert_select "h2", text: @post.title
    assert_select "h2", text: @draft.title, count: 0
  end

  # Both counts load whichever tab is showing, so the one you are not on still
  # tells you there is something waiting in it.
  test "both tabs carry their own count" do
    sign_in users(:one)

    get mine_posts_url

    assert_response :success
    assert_select "a[href=?]", mine_posts_path, text: /Published\s*1/
    assert_select "a[href=?]", mine_posts_path(tab: "drafts"), text: /Drafts\s*1/
  end

  test "my stories never lists someone else's post" do
    sign_in users(:one)

    get mine_posts_url

    assert_response :success
    assert_select "h2", text: posts(:two).title, count: 0
  end


  test "should require authentication to create a new post" do
    get new_post_url

    assert_redirected_to new_user_session_path
  end

  test "should get new when signed in" do
    sign_in users(:one)

    get new_post_url

    assert_response :success
  end

  test "should create post owned by the signed in user" do
    sign_in users(:one)

    assert_difference("Post.count") do
      post posts_url, params: { post: { title: @post.title } }
    end

    assert_equal users(:one), Post.last.user
    assert_redirected_to post_url(Post.last)
  end

  test "should show a published post to anyone" do
    get post_url(@post)
    assert_response :success
  end

  # The flip side of a public archive: an unpublished post must stay private,
  # otherwise every draft is one guessed id away from being readable.
  test "should not show an unpublished post to a signed out visitor" do
    get post_url(@draft)

    assert_response :not_found
  end

  test "should not show an unpublished post to another signed in user" do
    sign_in users(:two)

    get post_url(@draft)

    assert_response :not_found
  end

  test "should show an unpublished post to its author" do
    sign_in users(:one)

    get post_url(@draft)

    assert_response :success
  end

  test "anonymous view increments views_count" do
    assert_difference("@post.reload.views_count", 1) do
      get post_url(@post)
    end
  end

  test "signed in author's view does not increment views_count" do
    sign_in users(:one)

    assert_no_difference("@post.reload.views_count") do
      get post_url(@post)
    end
  end

  test "should get edit for owner" do
    sign_in users(:one)

    get edit_post_url(@post)
    assert_response :success
  end

  test "should not get edit for a post owned by someone else" do
    sign_in users(:two)

    get edit_post_url(@post)
    assert_redirected_to post_url(@post)
  end

  test "should update post as owner" do
    sign_in users(:one)

    patch post_url(@post), params: { post: { title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should not update post owned by someone else" do
    sign_in users(:two)

    patch post_url(@post), params: { post: { title: "Hijacked" } }
    assert_redirected_to post_url(@post)
    assert_not_equal "Hijacked", @post.reload.title
  end

  test "should destroy post as owner" do
    sign_in users(:one)

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to mine_posts_url
  end

  test "should not destroy post owned by someone else" do
    sign_in users(:two)

    assert_no_difference("Post.count") do
      delete post_url(@post)
    end

    assert_redirected_to post_url(@post)
  end
end
