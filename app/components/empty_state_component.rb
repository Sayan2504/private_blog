# frozen_string_literal: true

# The blank slate shared by every list view. There are now three of them —
# All stories, My stories and Draft — plus the dashboard, and each needs the same
# centred panel with a different icon, message and (optionally) a call to
# action. The CTA is optional on purpose: a signed-out reader looking at an
# empty archive has nothing useful to click, and shouldn't be handed a button
# that only redirects to a sign-in screen.
class EmptyStateComponent < ViewComponent::Base
  ICONS = {
    document: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"/>',
    draft: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>'
  }.freeze

  def initialize(title:, body:, icon: :document, cta_label: nil, cta_href: nil)
    @title = title
    @body = body
    @icon = icon
    @cta_label = cta_label
    @cta_href = cta_href
  end

  private

  attr_reader :title, :body, :cta_label, :cta_href

  def icon_path
    ICONS.fetch(@icon, ICONS[:document]).html_safe
  end

  def cta?
    cta_label.present? && cta_href.present?
  end
end
