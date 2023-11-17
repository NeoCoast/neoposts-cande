# frozen_string_literal: true

class LikesController < ApplicationController
  def create
    @like = Like.new(
      user: current_user
    )
    set_likeable(params[:likeable_type], params[:likeable_id])
    nil unless @like.save
  end

  def destroy
    likeable_id = params[:likeable_id]
    @like = Like.find_by(user_id: current_user.id, likeable_id:)
    @like.destroy
  end

  private

  def set_likeable(likeable_type, likeable_id)
    @likeable = likeable_type.constantize.find(likeable_id)
    @like.likeable = @likeable
  end
end
