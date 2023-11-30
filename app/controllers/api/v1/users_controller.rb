# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      def index
        @users = User.all
        render 'api/v1/users/index', formats: [:json]
      end
    end
  end
end
