class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    Post.due_to_publish.find_each do |post|
      post.update!(published_at: post.scheduled_for || Time.current, scheduled_for: nil)
    end
  end
end

