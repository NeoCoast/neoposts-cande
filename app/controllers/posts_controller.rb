# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy]

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

  def show; end

  def index
    posts = current_user.followed_posts
    sort_by = params[:sort_by]
    @posts = define_posts(sort_by, posts)
    respond_to_index
  end

  def destroy
    @post.destroy
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end

  def respond_to_index
    respond_to do |format|
      format.html
      format.js do
        render partial: 'posts/post', collection: @posts, locals: { in_index: true.to_s }, layout: false,
               content_type: 'text/html'
      end
    end
  end

  # :reek:ControlParameter
  def define_posts(sort_by, posts)
    @posts = if sort_by == 'trending'
               Post.by_trending(current_user.followed_posts)
             elsif sort_by == 'likes'
               posts.by_likes
             else
               posts.by_publishing_date
             end
    @posts
  end
end
