# frozen_string_literal: true

json.extract! @post, :id, :title, :body, :published_at, :user_id
json.likes @post.likes do |like|
  json.extract! like, :user_id
  json.nickname like.user.nickname
end
json.comments @post.comments do |comment|
  json.extract! comment, :id, :content
  json.replies comment.comments, partial: 'api/v1/partials/comments', as: :comment
end
