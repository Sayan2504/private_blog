# frozen_string_literal: true

# The app's own confirmation dialog, replacing `window.confirm`.
#
# Rendered exactly once, in the layout, and reused by every confirmation in the
# app: Turbo routes all of them through one function (see confirm_controller.js),
# so there is one dialog in the DOM rather than one per destructive button.
#
# It carries no state of its own — the title, message, button label and variant
# are all written in by the controller from the element that asked. What lives
# here is the shape: which pieces exist and how they are arranged.
class ConfirmDialogComponent < ViewComponent::Base
  # The two intents a confirmation can have. Both are rendered and the
  # controller reveals one, so each keeps its real ButtonComponent styling
  # instead of having Tailwind class strings assembled in JavaScript.
  VARIANTS = {
    danger: {
      accent: "bg-red-50 text-red-600 dark:bg-red-950/60 dark:text-red-400",
      icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"/>'
    },
    primary: {
      accent: "bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-300",
      icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5.25h.008v.008H12v-.008z"/>'
    }
  }.freeze

  private

  def variants
    VARIANTS
  end

  def icon_for(key)
    VARIANTS.fetch(key)[:icon].html_safe
  end

  def accent_for(key)
    VARIANTS.fetch(key)[:accent]
  end

  def button_variant_for(key)
    key == :danger ? :danger : :primary
  end
end
