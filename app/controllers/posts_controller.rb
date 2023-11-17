# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @liked_by_current_user = @post.liked_by_current_user?(current_user)
  end

  def index
    @posts = current_user.followed_posts.ordered_posts
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
