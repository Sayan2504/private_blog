require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # window.confirm was replaced by the app's own dialog
  # (ConfirmDialogComponent), so Capybara's `accept_confirm` has no native
  # modal left to drive. These reach into the real one instead.
  def accept_dialog(label)
    within_dialog { click_on label }
  end

  def dismiss_dialog
    within_dialog { click_on "Cancel" }
  end

  def within_dialog(&block)
    within("dialog[open]", &block)
  end

  # Content below the fold starts at opacity 0 until the reveal observer
  # catches it (see reveal_controller.js), and Selenium counts that as not
  # displayed. Scrolling it into view is what a reader does anyway, and it is
  # the app's own pane that scrolls, not the window.
  def scroll_into_view(selector, text: nil)
    element = find(selector, text: text, visible: :all)
    page.execute_script("arguments[0].scrollIntoView({ block: 'center' })", element)
    element
  end
end
