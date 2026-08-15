require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should require authentication to view published" do
    get published_posts_url

    assert_redirected_to new_user_session_path
  end

  test "published page shows only the signed in user's own published stories" do
    sign_in users(:one)

    get published_posts_url

    assert_response :success
    assert_select "h1", text: /Your published stories/i
  end

  test "should require authentication to view drafts" do
    get drafts_posts_url

    assert_redirected_to new_user_session_path
  end

  test "should get drafts when signed in" do
    Post.create!(title: "Draft story", author: "Writer", user: users(:one))
    sign_in users(:one)

    get drafts_posts_url

    assert_response :success
    assert_select "h1", text: /Saved ideas, ready when you are/i
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

  test "should show post" do
    get post_url(@post)
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

    assert_redirected_to drafts_posts_url
  end

  test "should not destroy post owned by someone else" do
    sign_in users(:two)

    assert_no_difference("Post.count") do
      delete post_url(@post)
    end

    assert_redirected_to post_url(@post)
  end
end
