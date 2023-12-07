# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      before_action :find_user, only: %i[index create]
      before_action :find_post, only: %i[show update]

      def index
        return render json: { message: 'User does not exist' }, status: :bad_request unless @user.present?

        @posts = @user.posts.order(published_at: :desc)
      end

      def show
        render json: { message: 'Post does not exist' }, status: :bad_request unless @post.present?
      end

      def create
        return render json: { message: 'Unauthorized' }, status: :unauthorized unless @user == current_user

        @post = @user.posts.build(post_params)
        @post.save if validate_not_empty_attriutes(@post.title, @post.body)
      end

      def update
        return render json: { message: 'Unauthorized' }, status: :unauthorized unless @post&.user == current_user

        new_post = params[:post]
        return unless validate_not_empty_attriutes(new_post[:title], new_post[:body])

        @post.update(post_params)
        render 'api/v1/posts/create', formats: [:json], locals: { post: @post }
      end

      def validate_not_empty_attriutes(title, body)
        unless title.present? && body.present?
          render json: { message: 'Title and body cannot be blank' }, status: :bad_request
          return false
        end
        true
      end

      def find_user
        @user = User.find_by(id: params[:user_id])
      end

      def find_post
        @post = Post.find_by(id: params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
