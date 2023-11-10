# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:relationship][:followed_id])
    current_user.follow(user)
    attachment_partial = render_to_string(partial: 'users/user_btn', locals: { user: current_user })
    render json: { attachment_partial: }
  end

  def destroy
    user = User.find(params[:relationship][:followed_id])
    current_user.unfollow(user)
    respond_to_unfollow
  end

  private

  def respond_to_unfollow
    respond_to do |format|
      format.html { format.json { head :no_content } }
      format.js
    end
  end
end
