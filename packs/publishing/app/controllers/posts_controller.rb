class PostsController < ApplicationController
  # `show` and `published` are the public face of MindCanvas: anyone, signed in
  # or not, can read a published post and browse the full published archive.
  # Everything else is authoring, and needs an account.
  before_action :authenticate_user!, except: %i[ show published ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authorize_reader!, only: :show
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  PER_PAGE = 12

  # Every published post, by every author. The public archive.
  def published
    @query = params[:q].to_s
    @tag = params[:tag].to_s
    @page = [ params[:page].to_i, 1 ].max
    @popular_tags = Tag.popular.limit(12)

    scope = Post.published.with_associations.tagged_with(@tag).search(@query)
    @posts = scope.limit(PER_PAGE + 1).offset((@page - 1) * PER_PAGE).to_a
    @has_more = @posts.size > PER_PAGE
    @posts = @posts.first(PER_PAGE)

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  # Everything the signed-in user has written, split across two tabs. Published
  # is the default: it is the finished work, and the reason you come here.
  # Drafts sit one click away rather than on a route of their own — the two
  # are the same post either side of publishing, and splitting them into
  # separate destinations made the sidebar list a state as if it were a place.
  #
  # Both counts are always loaded, so the inactive tab can carry its own number
  # and you can see there is something waiting in the other one.
  def mine
    posts = current_user.posts
    @tab = params[:tab] == "drafts" ? :drafts : :published
    @published_count = posts.published.count
    @draft_count = posts.drafts.count
    @posts = (@tab == :drafts ? posts.drafts : posts.published).with_associations
  end

  def show
    track_view!
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build
    result = Posts::Save.new(post: @post, params: post_params, publish: params[:publish].present?).call

    respond_to do |format|
      if result.saved?
        format.html { redirect_to @post, notice: result.notice }
        format.json { render json: { id: @post.id, url: post_path(@post), saved_at: Time.current.strftime("%-I:%M %p") }, status: :created }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: { errors: @post.errors.full_messages }, status: :unprocessable_content }
      end
    end
  end

  # Three outcomes share this action, decided by which submit button was used:
  # save in place, publish a draft, or pull a published story back to drafts.
  def update
    result = Posts::Save.new(
      post: @post,
      params: post_params,
      publish: params[:publish].present?,
      unpublish: params[:unpublish].present?
    ).call

    respond_to do |format|
      if result.saved?
        format.html { redirect_to @post, notice: result.notice, status: :see_other }
        format.json { render json: { id: @post.id, url: post_path(@post), saved_at: Time.current.strftime("%-I:%M %p") } }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: { errors: @post.errors.full_messages }, status: :unprocessable_content }
      end
    end
  end

  def destroy
    destination = @post.published? ? mine_posts_path : mine_posts_path(tab: "drafts")
    @post.destroy!

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Post was successfully destroyed."
      end
      format.html do
        redirect_to destination, notice: "Post was successfully destroyed.", status: :see_other
      end
    end
  end

  private

  def set_post
    @post = Post.find_by_slug_or_id!(params.expect(:id))
  end

  def post_policy
    @post_policy ||= PostPolicy.new(current_user, @post)
  end

  # The flip side of a public archive: if published posts are readable by
  # anyone, unpublished ones must be readable by their author alone. Without
  # this, any draft was one guessed id away from being public.
  def authorize_reader!
    return if post_policy.show?

    raise ActiveRecord::RecordNotFound
  end

  def authorize_owner!
    redirect_to @post, alert: "You can only manage your own posts." unless post_policy.update?
  end

  def track_view!
    return if user_signed_in?

    viewed = (session[:viewed_post_ids] ||= [])
    return if viewed.include?(@post.id)

    viewed << @post.id
    IncrementPostViewsJob.perform_later(@post.id)
  end

  def post_params
    params.expect(post: [ :title, :author, :content, :tag_list, :cover_image, :scheduled_for ])
  end
end
