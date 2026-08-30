require "application_system_test_case"

# The auth cards animate their contents in rather than appearing as one block.
# The failure mode worth guarding is not "the animation looks wrong" but
# "something never arrives" — a reveal item that is never revealed stays at
# opacity 0, which is invisible content, not a missing flourish.
class AuthMotionTest < ApplicationSystemTestCase
  PAGES = {
    "sign-in" => "/users/sign_in",
    "sign-up" => "/users/sign_up",
    "password reset" => "/users/password/new"
  }.freeze

  PAGES.each do |name, path|
    test "every element on the #{name} card ends fully visible" do
      visit path

      assert_settles("#{name}: reveal items should all resolve") do
        pending_items(path).zero?
      end

      faded = page.evaluate_script(<<~JS)
        Array.from(document.querySelectorAll('.surface-float *'))
          .filter(el => el.children.length === 0 && el.textContent.trim() !== '')
          .filter(el => parseFloat(getComputedStyle(el).opacity) < 1)
          .map(el => el.textContent.trim().slice(0, 30))
      JS

      assert_empty faded, "#{name}: these never finished arriving"
    end
  end

  test "the card carries the travel and its contents carry the fade" do
    visit "/users/sign_in"

    # Sampled immediately, while the cascade is still running: the frame must
    # never be transparent, or it would be multiplying its children's fade.
    frame_opacity = page.evaluate_script(
      "getComputedStyle(document.querySelector('[data-reveal-frame]')).opacity"
    ).to_f

    assert_equal 1.0, frame_opacity, "the card must travel, not fade"
  end

  test "the contents arrive in sequence rather than all at once" do
    visit "/users/sign_up"

    # Each item is given a transition-delay proportional to its position, which
    # is what makes the arrival a cascade rather than one block.
    #
    # Those delays are deliberately short-lived — reveal_controller strips them
    # once an item has landed, so that it stops shadowing whatever transition
    # the element declares for itself. A single sample therefore races the
    # animation and can arrive before the delays are written or after they are
    # cleared. Accumulating across a poll catches the window either way.
    observed = []
    deadline = Time.now + 3

    loop do
      observed |= page.evaluate_script(<<~JS)
        Array.from(document.querySelectorAll('[data-reveal-wave]'))
          .map(el => el.style.transitionDelay)
          .filter(d => d && d !== '0s')
      JS

      break if observed.size > 1 || Time.now > deadline
      sleep 0.02
    end

    assert_operator observed.size, :>, 1, "expected staggered delays, saw #{observed.inspect}"
  end

  private

  def pending_items(_path)
    page.evaluate_script("document.querySelectorAll('[data-reveal-item]').length")
  end

  def assert_settles(message, timeout: 5)
    deadline = Time.now + timeout
    loop do
      return if yield
      flunk(message) if Time.now > deadline
      sleep 0.05
    end
  end
end
