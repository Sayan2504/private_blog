require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "homepage shows published stories without draft tabs" do
    get posts_url

    assert_response :success
    assert_select "h2", text: /What’s live right now/i
    assert_select "a", text: /Drafts/i, count: 0
  end

  test "signed in user sees their drafts section" do
    Post.create!(title: "Draft story", author: "Writer")
    sign_in users(:one)

    get posts_url

    assert_response :success
    assert_select "h2", text: /Saved ideas, ready when you are./i
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

  test "should create post" do
    sign_in users(:one)

    assert_difference("Post.count") do
      post posts_url, params: { post: { title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)

    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    sign_in users(:one)

    patch post_url(@post), params: { post: { title: @post.title } }
    assert_redirected_to post_url(@post)
  end

  test "should destroy post" do
    sign_in users(:one)

    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
