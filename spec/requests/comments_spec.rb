# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe '#create_comment_request' do
    let(:post1) { create :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:comment) { create :comment, user:, commentable: post1 }

    it 'with no logged user - redirects to login' do
      post post_comments_path(post1),
           params: { comment: { content: comment.content }, commentable_type: 'Post', commentable_id: post1.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
    end

    context 'comment a post' do
      before do
        sign_in user
        post post_comments_path(post1),
             params: { comment: { content: comment.content }, commentable_type: 'Post', commentable_id: post1.id }
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies comment count increases' do
        count = Comment.count
        post post_comments_path(post1),
             params: { comment: { content: comment.content }, commentable_type: 'Post', commentable_id: post1.id }
        expect(Comment.count).to be(count + 1)
      end

      it 'verifies posts comment count increases' do
        count = post1.comments.count
        post post_comments_path(post1),
             params: { comment: { content: comment.content }, commentable_type: 'Post', commentable_id: post1.id }
        expect(post1.comments.count).to be(count + 1)
      end

      it 'verifies last comment content is correct' do
        expect(Comment.last.content).to eq(comment.content)
      end
    end

    context 'comment a comment' do
      before do
        sign_in user
        post comment_comments_path(comment),
             params: { comment: { content: comment.content }, commentable_type: 'Comment', commentable_id: comment.id }
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies comment count increases' do
        count = Comment.count
        post comment_comments_path(comment),
             params: { comment: { content: comment.content }, commentable_type: 'Comment', commentable_id: comment.id }
        expect(Comment.count).to be(count + 1)
      end

      it 'verifies posts comment count increases' do
        count = comment.comments.count
        post comment_comments_path(comment),
             params: { comment: { content: comment.content }, commentable_type: 'Comment', commentable_id: comment.id }
        expect(comment.comments.count).to be(count + 1)
      end

      it 'verifies last comment content is correct' do
        expect(Comment.last.content).to eq(comment.content)
      end
    end
  end
end
