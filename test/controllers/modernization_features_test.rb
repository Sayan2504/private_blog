require "test_helper"

class ModernizationFeaturesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @post = posts(:one)
    @other_post = posts(:two)
    @post.update!(title: @post.title)
    @other_post.update!(title: @other_post.title)
  end

  test "full-text search finds published stories" do
    get published_posts_url(q: "Another")
    assert_response :success
    assert_match @other_post.title, response.body
    assert_no_match @post.title, response.body
  end

  test "scheduled publishing job publishes due posts" do
    draft = posts(:draft_one)
    draft.update!(scheduled_for: 5.minutes.ago)

    PublishScheduledPostsJob.perform_now
    assert_predicate draft.reload, :published?
    assert_nil draft.scheduled_for
  end

  test "rss feed and sitemap return valid xml" do
    get published_posts_url(format: :rss)
    assert_response :success
    assert_equal "application/rss+xml", response.media_type
    assert_match @post.title, response.body

    get sitemap_url
    assert_response :success
    assert_equal "application/xml", response.media_type
    assert_match post_url(@post), response.body
  end

  test "command palette search returns stories" do
    get search_url(q: "Another")
    assert_response :success
    assert_match @other_post.title, response.body
  end

  test "following an author filters dashboard feed and creates notification" do
    sign_in @user

    assert_difference("Follow.count", 1) do
      assert_difference("Notification.count", 1) do
        post follows_url(author_id: @other_user.id), as: :turbo_stream
      end
    end
    assert_response :success

    get dashboard_url(feed: "following")
    assert_response :success
    assert_match @other_post.title, response.body

    follow = @user.active_follows.find_by!(followed: @other_user)
    assert_difference("Follow.count", -1) do
      delete follow_url(follow), as: :turbo_stream
    end
    assert_response :success
  end

  test "notifications index marks unread notifications as read" do
    sign_in @other_user
    post post_comments_url(@post), params: { comment: { body: "Nice!" } }, as: :turbo_stream
    assert_equal 1, @user.notifications.unread.count

    sign_in @user
    get notifications_url
    assert_response :success
    assert_match "commented", response.body
    assert_equal 0, @user.notifications.unread.count
  end
end

