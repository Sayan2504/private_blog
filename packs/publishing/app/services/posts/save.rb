module Posts
  class Save
    Result = Struct.new(:saved?, :notice, keyword_init: true)

    def initialize(post:, params:, publish: false, unpublish: false)
      @post = post
      @params = params
      @publish = publish
      @unpublish = unpublish
    end

    def call
      was_new = @post.new_record?
      unpublishing = !was_new && @unpublish && @post.published?

      @post.assign_attributes(@params)
      if @publish && !@post.published?
        @post.published_at = Time.current
        @post.scheduled_for = nil
      end
      if unpublishing
        @post.published_at = nil
        @post.scheduled_for = nil
      end

      if @post.save
        Result.new(saved?: true, notice: success_notice(was_new, unpublishing))
      else
        Result.new(saved?: false, notice: nil)
      end
    end

    private

    def success_notice(was_new, unpublishing)
      return "Post was successfully created." if was_new
      return "Story moved back to drafts." if unpublishing

      "Post was successfully updated."
    end
  end
end
