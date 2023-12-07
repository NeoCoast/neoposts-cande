# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :find_post, only: %i[show destroy]
  before_action :followed_posts, :define_posts, only: :index

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
    attachment_partial = render_to_string(partial: 'posts/post', collection: @posts, locals: { in_index: true.to_s })
    respond_to_index(attachment_partial)
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

  def respond_to_index(attachment_partial)
    respond_to do |format|
      format.html
      format.json { render json: { attachment_partial: } }
    end
  end

  def followed_posts
    @posts = current_user.followed_posts
  end

  def define_posts
    @posts = @posts
             .filter_author(params[:author_filter])
             .filter_body(params[:body_filter])
             .filter_title(params[:title_filter])
             .filter_date(params[:date_filter])
    @posts = @posts.sort_posts(params[:sort_by])
  end
end
