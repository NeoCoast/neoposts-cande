# frozen_string_literal: true

def render_comments(json, comments)
  json.replies comments do |comment|
    json.extract! comment, :id, :content
    render_comments(json, comment.comments)
  end
end

json.extract! @post, :id, :title, :body, :published_at, :user_id
json.likes @post.likes do |like|
  json.extract! like, :user_id
  user = User.find(like.user_id)
  json.extract! user, :nickname
end
json.comments @post.comments do |comment|
  json.extract! comment, :id, :content
  render_comments(json, comment.comments)
end
