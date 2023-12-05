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

      def update
        @post = Post.find(params[:id])
        @post.update(params.require(:post).permit(:title, :body))
        if validate_not_empty_attriutes(@post)
          @post.save
          render 'api/v1/posts/create', formats: [:json], locals: { post: @post }
        end
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Post does not exist' }, status: :not_found
      end

      # :reek:ControlParameter
      def validate_post(user, post)
        if user != current_user
          render json: { message: 'Unauthorized' }, status: :unauthorized
          return false
        end
        validate_not_empty_attriutes(post)
      end

      def validate_not_empty_attriutes(post)
        unless post.valid?
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
