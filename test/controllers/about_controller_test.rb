require "test_helper"

class AboutControllerTest < ActionDispatch::IntegrationTest
  test "is public, no authentication required" do
    get about_url

    assert_response :success
  end

  # The whole point of AboutHelper::CAREER_START_YEAR: the page has to say the
  # right number of years without anyone editing it in January. Travelling to
  # a future year proves the text follows the clock rather than a literal.
  test "years of experience count up with the calendar" do
    travel_to Time.zone.local(2031, 3, 1) do
      get about_url

      assert_response :success
      assert_select "p", text: "11+ years"
    end
  end

  test "leads with the platform, not with a personal blog" do
    get about_url

    assert_select "h1", text: /a quiet place to write/i
  end
end
