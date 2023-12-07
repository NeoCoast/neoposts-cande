# frozen_string_literal: true

module Api
  module V1
    class PostsController < Api::V1::BaseController
      before_action :find_user, only: %i[index create]
      before_action :find_post, only: %i[show update]

      def index
        @posts = @user.posts.order(published_at: :desc)
      end

      def show; end

      def create
        @post = @user.posts.build(post_params)
        @post.save if validate_post(@user, @post)
      end

      def update
        return unless validate_not_empty_attriutes(post_params[:title], post_params[:body])

        @post.update(post_params)
        render 'api/v1/posts/create', formats: [:json], locals: { post: @post }
      end

      # :reek:ControlParameter
      def validate_post(user, post)
        if user != current_user
          render json: { message: 'Unauthorized' }, status: :unauthorized
          return false
        end
        validate_not_empty_attriutes(post.title, post.body)
      end

      def validate_not_empty_attriutes(title, body)
        unless title.present? && body.present?
          render json: { message: 'Title and body cannot be blank' }, status: :bad_request
          return false
        end
        true
      end

      def find_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end

      def find_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
