# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[following followers]

  def show
    @user = User.find_by(nickname: params[:nickname])

    return redirect_to root_path, alert: 'User not found' unless @user

    @posts = @user.posts.order(published_at: :desc)
  end

  def index
    @users = User.order(:nickname).page params[:page]
  end

  def following; end
  def followers; end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
