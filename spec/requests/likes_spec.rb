# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe '#create_like_request' do
    let(:post1) { create :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:comment) { create :comment, user:, commentable: post1 }

    it 'with no logged user - redirects to login' do
      post post_likes_path(post1),
           params: { likeable_type: 'Post', likeable_id: post1.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'with no logged user - redirects to login' do
      post comment_likes_path(comment),
           params: { likeable_type: 'Comment', likeable_id: comment.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
    end

    context 'like a post' do
      before do
        sign_in user
      end

      it 'verifies response is success' do
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count increases' do
        count = Like.count
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
        expect(Like.count).to be(count + 1)
      end

      it 'verifies posts comment count increases' do
        count = post1.likes.count
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
        expect(post1.likes.count).to be(count + 1)
      end

      it 'verifies last liked post is correct' do
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
        expect(Like.last.likeable_id).to eq(post1.id)
      end
    end

    context 'like a comment' do
      before do
        sign_in user
      end

      it 'verifies response is success' do
        post comment_likes_path(post1),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count increases' do
        count = Like.count
        post comment_likes_path(post1),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(Like.count).to be(count + 1)
      end

      it 'verifies posts comment count increases' do
        count = post1.likes.count
        post comment_likes_path(post1),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(comment.likes.count).to be(count + 1)
      end

      it 'verifies last liked post is correct' do
        post comment_likes_path(post1),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(Like.last.likeable_id).to eq(comment.id)
      end
    end
  end

  describe '#delete_like_request' do
    let(:post1) { create :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:comment) { create :comment, user:, commentable: post1 }

    it 'with no logged user - redirects to login' do
      post post_likes_destroy_post_path(post1),
           params: { likeable_id: post1.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'with no logged user - redirects to login' do
      post comment_likes_destroy_comment_path(comment),
           params: { likeable_id: comment.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
    end

    context 'delete post like' do
      before do
        sign_in user
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
      end

      it 'verifies response is success' do
        delete post_likes_destroy_post_path(post1),
               params: { likeable_id: post1.id }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count increases' do
        count = Like.count
        delete post_likes_destroy_post_path(post1),
               params: { likeable_id: post1.id }
        expect(Like.count).to be(count - 1)
      end

      it 'verifies posts comment count increases' do
        count = post1.likes.count
        delete post_likes_destroy_post_path(post1),
               params: { likeable_id: post1.id }
        expect(post1.likes.count).to be(count - 1)
      end
    end

    context 'delete comment like' do
      before do
        sign_in user
        post comment_likes_path(comment),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
      end

      it 'verifies response is success' do
        delete comment_likes_destroy_comment_path(comment),
               params: { likeable_id: comment.id }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count increases' do
        count = Like.count
        delete comment_likes_destroy_comment_path(comment),
               params: { likeable_id: comment.id }
        expect(Like.count).to be(count - 1)
      end

      it 'verifies comments comment count increases' do
        count = comment.likes.count
        delete comment_likes_destroy_comment_path(comment),
               params: { likeable_id: comment.id }
        expect(comment.likes.count).to be(count - 1)
      end
    end
  end
end
