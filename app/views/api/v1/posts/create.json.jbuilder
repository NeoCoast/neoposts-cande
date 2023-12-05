# frozen_string_literal: true

json.extract! @post, :id, :title, :body, :published_at, :user_id, :comments_count, :likes_count
