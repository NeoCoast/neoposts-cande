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
  end

  def index
    @posts = current_user.followed_posts.ordered_posts
  end

  def destroy
    @post = Post.find(params[:id])
    @post.likes.destroy_all
    delete_comments_and_likes(@post.comments)
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

  def delete_comments_and_likes(comments)
    comments.each do |comment|
      comment.likes.destroy_all
      delete_comments_and_likes(comment.comments)
      comment.destroy
    end
  end
end
