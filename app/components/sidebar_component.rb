# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  include Rails.application.routes.url_helpers

  NavItem = Struct.new(:label, :href, :icon, :active, keyword_init: true)

  def initialize(active: nil)
    @active = active
  end

  private

  def nav_items
    [
      NavItem.new(label: "Dashboard", href: dashboard_path, icon: :dashboard, active: @active == :dashboard),
      NavItem.new(label: "Published", href: published_posts_path, icon: :published, active: @active == :published),
      NavItem.new(label: "Draft", href: drafts_posts_path, icon: :draft, active: @active == :drafts)
    ]
  end

  def nav_icon(icon)
    case icon
    when :dashboard
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M3.75 3.75h6v6h-6v-6zm10.5 0h6v6h-6v-6zm0 10.5h6v6h-6v-6zm-10.5 0h6v6h-6v-6z"/></svg>'
    when :published
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M12 21c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M3.6 9h16.8M3.6 15h16.8M12 3a14.5 14.5 0 010 18M12 3a14.5 14.5 0 000 18"/></svg>'
    when :draft
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>'
    end.html_safe
  end
end
