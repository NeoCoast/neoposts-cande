# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      def index
        user = User.find(params[:user_id])
        @posts = user.posts
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'User does not exist' }, status: :not_found
      end

      def show
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Post does not exist' }, status: :not_found
      end

      def create
        user = User.find(params[:user_id])
        @post = user.posts.build(params.require(:post).permit(:title, :body))
        @post.save if validate_post(user, @post)
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'User does not exist' }, status: :not_found
      end

      def validate_post(user, post)
        if user.email != request.headers['uid']
          render json: { message: 'Unauthorized' }, status: :unauthorized
          return false
        elsif !post.valid?
          render json: { errors: post.errors }, status: :bad_request
          return false
        end
        true
      end
    end
  end
end
