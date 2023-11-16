# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(
      user: current_user,
      content: params[:comment][:content]
    )
    set_commentable(params[:commentable_type], params[:commentable_id])

    return unless @comment.save

    render_comment
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable(commentable_type, commentable_id)
    @commentable = commentable_type.constantize.find(commentable_id)
    @comment.commentable = @commentable
  end

  def render_comment
    attachment_partial = render_to_string(partial: 'posts/comment',
                                          locals: { comment: @comment })
    render json: { attachment_partial: }
  end
end
