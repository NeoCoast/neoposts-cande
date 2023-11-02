# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(nickname: params[:nickname])

    return redirect_to root_path, alert: 'User not found' unless @user

    @posts = @user.posts.order(published_at: :desc)
  end

  def index
    @users = User.order(:nickname).page params[:page]
  end
end
