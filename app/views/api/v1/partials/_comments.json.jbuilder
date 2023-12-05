# frozen_string_literal: true

json.extract! comment, :id, :content
json.replies comment.comments, partial: 'api/v1/partials/comments', as: :comment
