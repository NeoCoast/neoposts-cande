# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    if user_signed_in?
      @post = current_user.posts.new(post_params)
      if @post.save
        redirect_to @post
      else
        render 'new'
      end
    else
      no_signed_user
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def no_signed_user
    redirect_to new_user_session_path
    flash[:alert] = 'Please sign in to create a post.'
  end

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
