require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "is public, no authentication required" do
    get dashboard_url

    assert_response :success
    assert_select "h1", text: /MindCanvas, at a glance/i
  end

  test "shows metrics when signed in too" do
    sign_in users(:one)

    get dashboard_url

    assert_response :success
    assert_select "h1", text: /MindCanvas, at a glance/i
  end

  # A draft count is an authoring detail. A reader has no drafts and no
  # business seeing anyone else's, so the tile only exists once signed in.
  test "hides the drafts tile from signed out readers" do
    get dashboard_url

    assert_response :success
    assert_select "p", text: /Your drafts/i, count: 0
  end

  test "shows your own draft count when signed in" do
    sign_in users(:one)

    get dashboard_url

    assert_response :success
    assert_select "p", text: /Your drafts/i
  end

  # The sidebar renders from the layout, so the dashboard is the cheapest
  # place to pin down which destinations each kind of visitor is offered.
  test "signed out navigation offers no authoring destinations" do
    get dashboard_url

    assert_select "nav a[href=?]", published_posts_path
    assert_select "nav a[href=?]", about_path
    assert_select "nav a[href=?]", mine_posts_path, count: 0
  end

  test "signed in navigation offers your own work" do
    sign_in users(:one)

    get dashboard_url

    assert_select "nav a[href=?]", published_posts_path
    assert_select "nav a[href=?]", mine_posts_path
  end
end
