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
end
