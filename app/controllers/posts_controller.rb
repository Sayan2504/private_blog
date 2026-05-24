class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @tab = params[:tab]&.to_s == "drafts" ? "drafts" : "published"
    @posts = @tab == "drafts" ? Post.drafts : Post.published
    @recent_posts = Post.published.limit(5)
    @drafts_count = Post.drafts.count
    @published_count = Post.published.count
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.published_at = Time.current if params[:publish]

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @post.published_at = Time.current if params[:publish] && !@post.published?

    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params.expect(:id))
  end

  def post_params
    params.expect(post: [ :title, :subtitle, :author, :content ])
  end
end
