# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      before_action :find_user, only: %i[index create]

      def index
        @posts = @user.posts
      end

      def show
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Post does not exist' }, status: :not_found
      end

      def create
        @post = @user.posts.build(params.require(:post).permit(:title, :body))
        @post.save if validate_post(@user, @post)
      end

      # :reek:ControlParameter
      def validate_post(user, post)
        if user != current_user
          render json: { message: 'Unauthorized' }, status: :unauthorized
          return false
        elsif !post.valid?
          render json: { errors: post.errors }, status: :bad_request
          return false
        end
        true
      end

      def find_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'User does not exist' }, status: :not_found
      end
    end
  end
end
