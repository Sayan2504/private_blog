# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  include Rails.application.routes.url_helpers

  NavItem = Struct.new(:label, :href, :icon, :active, keyword_init: true)

  def initialize(active: nil, user_signed_in: false)
    @active = active
    @user_signed_in = user_signed_in
  end

  private

  attr_reader :user_signed_in

  # Two navs, not one with disabled rows. A signed-out reader gets only the
  # places they can actually go — the overview, the public archive, and who
  # writes here. Your own work appears once there is an account behind it, so
  # nobody is offered a link that only bounces them to a sign-in screen.
  #
  # Drafts are not a nav entry: they are a tab inside My stories. The nav lists
  # places, and a draft is a state of a post rather than somewhere to go.
  def nav_items
    items = [
      NavItem.new(label: "Dashboard", href: dashboard_path, icon: :dashboard, active: @active == :dashboard),
      NavItem.new(label: "All stories", href: published_posts_path, icon: :published, active: @active == :published)
    ]

    if user_signed_in
      items << NavItem.new(label: "My stories", href: mine_posts_path, icon: :mine, active: @active == :mine)
    end

    items << NavItem.new(label: "About", href: about_path, icon: :about, active: @active == :about)
    items
  end

  def nav_icon(icon)
    case icon
    when :dashboard
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M3.75 3.75h6v6h-6v-6zm10.5 0h6v6h-6v-6zm0 10.5h6v6h-6v-6zm-10.5 0h6v6h-6v-6z"/></svg>'
    when :published
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M12 21c-4.97 0-9-4.03-9-9s4.03-9 9-9 9 4.03 9 9-4.03 9-9 9z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M3.6 9h16.8M3.6 15h16.8M12 3a14.5 14.5 0 010 18M12 3a14.5 14.5 0 000 18"/></svg>'
    when :mine
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M6.75 3.75h10.5a1.5 1.5 0 011.5 1.5v15l-6.75-3.75L5.25 20.25v-15a1.5 1.5 0 011.5-1.5z"/></svg>'
    when :about
      '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.5 20.25a7.5 7.5 0 0115 0"/></svg>'
    end.html_safe
  end
end
