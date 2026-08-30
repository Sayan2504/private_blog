class PostsController < ApplicationController
  # `show` and `published` are the public face of MindCanvas: anyone, signed in
  # or not, can read a published post and browse the full published archive.
  # Everything else is authoring, and needs an account.
  before_action :authenticate_user!, except: %i[ show published ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authorize_reader!, only: :show
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  # Every published post, by every author. The public archive.
  def published
    @posts = Post.published
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
    @posts = @tab == :drafts ? posts.drafts : posts.published
  end

  def show
    Post.increment_counter(:views_count, @post.id) unless user_signed_in?
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.published_at = Time.current if params[:publish]

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # Three outcomes share this action, decided by which submit button was used:
  # save in place, publish a draft, or pull a published story back to drafts.
  # Until now only the first two existed — the editor's "Save Draft" button
  # was a plain submit, so pressing it on an already-published post saved the
  # edit and left it published, which is the opposite of what it said.
  def update
    @post.published_at = Time.current if params[:publish] && !@post.published?

    unpublishing = params[:unpublish].present? && @post.published?
    @post.published_at = nil if unpublishing

    if @post.update(post_params)
      notice = unpublishing ? "Story moved back to drafts." : "Post was successfully updated."
      redirect_to @post, notice: notice, status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    # A deleted published post used to send you to the published archive, but
    # that list now belongs to everyone — your own list is the useful landing.
    # Deleting a draft lands you back on the tab you deleted it from.
    destination = @post.published? ? mine_posts_path : mine_posts_path(tab: "drafts")
    @post.destroy!
    redirect_to destination, notice: "Post was successfully destroyed.", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params.expect(:id))
  end

  # The flip side of a public archive: if published posts are readable by
  # anyone, unpublished ones must be readable by their author alone. Without
  # this, any draft was one guessed id away from being public.
  def authorize_reader!
    return if @post.published? || owner?(@post)

    raise ActiveRecord::RecordNotFound
  end

  def authorize_owner!
    redirect_to @post, alert: "You can only manage your own posts." unless owner?(@post)
  end

  # Compares ids rather than records: posts predating multi-user support can
  # have a nil user_id, and `nil == nil` would otherwise hand a signed-out
  # visitor ownership of every ownerless post.
  def owner?(post)
    user_signed_in? && post.user_id == current_user.id
  end

  def post_params
    params.expect(post: [ :title, :author, :content ])
  end
end
