require "test_helper"

class CommunityFeaturesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @post = posts(:one)
  end

  test "tagging a post and filtering published stories by tag" do
    sign_in @user

    patch post_url(@post), params: { post: { title: @post.title, tag_list: "rails, hotwire" } }
    assert_redirected_to post_url(@post)
    assert_equal %w[ rails hotwire ], @post.reload.tags.pluck(:name)

    get published_posts_url(tag: "rails")
    assert_response :success
    assert_match @post.title, response.body
    assert_no_match posts(:two).title, response.body
  end

  test "autosave draft via JSON creates and updates" do
    sign_in @user

    post posts_url, params: { post: { title: "Autosaved Draft" } }, as: :json
    assert_response :created
    data = JSON.parse(response.body)
    assert data["url"].present?
    assert data["saved_at"].present?

    patch data["url"], params: { post: { title: "Autosaved Draft v2" } }, as: :json
    assert_response :success
  end

  test "public author profile shows published stories" do
    get author_url(@user)
    assert_response :success
    assert_match @user.display_name, response.body
    assert_match @post.title, response.body
    assert_no_match posts(:draft_one).title, response.body
  end

  test "bookmarking and unbookmarking a story" do
    sign_in @user

    assert_difference("Bookmark.count", 1) do
      post bookmarks_url(post_id: @post), as: :turbo_stream
    end
    assert_response :success

    get bookmarks_url
    assert_response :success
    assert_match @post.title, response.body

    bookmark = @user.bookmarks.find_by!(post: @post)
    assert_difference("Bookmark.count", -1) do
      delete bookmark_url(bookmark), as: :turbo_stream
    end
    assert_response :success
  end

  test "clapping/reacting to a story increments reactions_count" do
    sign_in @user

    assert_difference("@post.reload.reactions_count", 1) do
      post post_reaction_url(@post), as: :turbo_stream
    end
    assert_response :success
  end

  test "creating and deleting comments with authorization" do
    sign_in @other_user

    assert_difference("Comment.count", 1) do
      post post_comments_url(@post), params: { comment: { body: "Great read!" } }, as: :turbo_stream
    end
    assert_response :success

    comment = @post.comments.last
    assert_difference("Comment.count", -1) do
      delete post_comment_url(@post, comment), as: :turbo_stream
    end
    assert_response :success
  end
end

