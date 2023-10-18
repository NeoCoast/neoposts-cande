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
    @last_post = Post.last
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :avatar)
  end
end
