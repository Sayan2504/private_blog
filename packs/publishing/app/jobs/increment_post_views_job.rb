class IncrementPostViewsJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    Post.increment_counter(:views_count, post_id)
  end
end
