require "application_system_test_case"

# The sidebar is a plain column from md up and a modal drawer below it. These
# tests run at phone width, where all of the modal behaviour lives.
class SidebarTest < ApplicationSystemTestCase
  PHONE = [ 390, 844 ].freeze

  setup do
    page.driver.browser.manage.window.resize_to(*PHONE)
  end

  teardown do
    page.driver.browser.manage.window.resize_to(1400, 1400)
  end

  test "the closed drawer is out of the tab order" do
    visit root_url

    # Sliding the panel off-canvas with a transform hides it from the eye but
    # not from the keyboard: without inert, tabbing out of the header walked
    # through nav links sitting entirely off screen.
    assert panel_inert?, "off-canvas panel should be inert"
    assert_equal "false", trigger["aria-expanded"]
  end

  test "opening the drawer traps the page behind it and moves focus in" do
    visit root_url
    trigger.click

    assert_selector "#sidebar-panel", visible: :visible
    assert_equal "true", trigger["aria-expanded"]
    assert_not panel_inert?, "open panel must be reachable"
    assert main_inert?, "the page behind the drawer should be out of reach"
    assert_equal "Close menu", page.evaluate_script("document.activeElement.getAttribute('aria-label')")
  end

  test "escape closes the drawer and hands focus back to the trigger" do
    visit root_url
    trigger.click
    assert main_inert?

    page.send_keys :escape

    assert panel_inert?, "dismissed panel should be inert again"
    assert_not main_inert?, "the page must be reachable once the drawer is gone"
    assert_equal "false", trigger["aria-expanded"]
    assert_equal "Open menu", page.evaluate_script("document.activeElement.getAttribute('aria-label')")
  end

  private

  def trigger
    find("[data-sidebar-target='trigger']")
  end

  def panel_inert?
    page.evaluate_script("document.getElementById('sidebar-panel').inert")
  end

  def main_inert?
    page.evaluate_script("document.querySelector(\"[data-sidebar-target='main']\").inert")
  end
end
