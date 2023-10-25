# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    if params[:nickname] == current_user.nickname
      @posts = current_user.posts.order(published_at: :desc)
    else
      redirect_to root_path
    end
  end
end
