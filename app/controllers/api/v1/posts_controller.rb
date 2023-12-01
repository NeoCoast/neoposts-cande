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
    end
  end
end
