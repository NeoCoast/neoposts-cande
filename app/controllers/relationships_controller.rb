# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:relationship][:followed_id])
    current_user.follow(user)
    respod_to_follow
  end

  def destroy
    user = User.find(params[:relationship][:followed_id])
    current_user.unfollow(user)
    respod_to_follow
  end

  private

  def respod_to_follow
    respond_to do |format|
      format.html { format.json { head :no_content } }
      format.js
    end
  end
end
