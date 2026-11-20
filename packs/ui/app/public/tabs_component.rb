# frozen_string_literal: true

class TabsComponent < ViewComponent::Base
  Tab = Struct.new(:label, :href, :active, keyword_init: true)

  def initialize(tabs:)
    @tabs = tabs
  end
end
