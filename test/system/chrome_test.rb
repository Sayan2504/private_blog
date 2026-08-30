require "application_system_test_case"

# App-frame behaviour that is not tied to any one page.
class ChromeTest < ApplicationSystemTestCase
  test "the first tab stop is a skip link that jumps past the navigation" do
    visit root_url
    page.send_keys :tab

    assert_equal "Skip to content", page.evaluate_script("document.activeElement.textContent.trim()")

    # Off-screen until focused, then it slides into the top-left gutter over
    # 220ms — so this waits for where it lands, not where it starts.
    assert_settles("the skip link should slide into view") do
      page.evaluate_script("document.querySelector('.skip-link').getBoundingClientRect().top") >= 0
    end

    page.send_keys :enter

    # Activating it must move focus, not merely scroll — that is the whole
    # point, and it is why <main> carries tabindex="-1".
    assert_settles("focus should land on the main landmark") do
      page.evaluate_script("document.activeElement.id") == "main-content"
    end
  end

  test "the active sidebar entry says so, not just looks so" do
    visit published_posts_url

    assert_selector "aside a[aria-current='page']", text: "All stories"
    assert_selector "aside a", text: "Dashboard"
    assert_no_selector "aside a[aria-current='page']", text: "Dashboard"
  end

  private

  # Polls a condition that resolves on a CSS transition rather than a DOM
  # change, which is the one thing Capybara's own waiting cannot see.
  def assert_settles(message, timeout: 2)
    deadline = Time.now + timeout
    loop do
      return if yield
      flunk(message) if Time.now > deadline
      sleep 0.05
    end
  end
end
