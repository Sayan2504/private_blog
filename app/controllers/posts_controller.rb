class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  def published
    @posts = current_user.posts.published
  end

  def drafts
    @posts = current_user.posts.drafts
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

  def update
    @post.published_at = Time.current if params[:publish] && !@post.published?

    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    destination = @post.published? ? published_posts_path : drafts_posts_path
    @post.destroy!
    redirect_to destination, notice: "Post was successfully destroyed.", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params.expect(:id))
  end

  def authorize_owner!
    redirect_to @post, alert: "You can only manage your own posts." unless @post.user == current_user
  end

  def post_params
    params.expect(post: [ :title, :author, :content ])
  end
end
