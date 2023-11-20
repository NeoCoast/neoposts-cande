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

      it 'verifies posts like count increases' do
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

      it 'verifies last like is a Post' do
        post post_likes_path(post1),
             params: { likeable_type: 'Post', likeable_id: post1.id }
        expect(Like.last.likeable_type).to eq('Post')
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

      it 'verifies comment like count increases' do
        count = comment.likes.count
        post comment_likes_path(comment),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(comment.likes.count).to be(count + 1)
      end

      it 'verifies last liked comment is correct' do
        post comment_likes_path(post1),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(Like.last.likeable_id).to eq(comment.id)
      end

      it 'verifies last like is a comment' do
        post comment_likes_path(comment),
             params: { likeable_type: 'Comment', likeable_id: comment.id }
        expect(Like.last.likeable_type).to eq('Comment')
      end
    end
  end

  describe '#delete_like_request' do
    let(:post1) { create :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:comment) { create :comment, user:, commentable: post1 }

    it 'with no logged user - redirects to login' do
      delete post_likes_destroy_post_path(post1),
             params: { likeable_id: post1.id, likeable_type: 'Post' }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'with no logged user - redirects to login' do
      delete comment_likes_destroy_comment_path(comment),
             params: { likeable_id: comment.id, likeable_type: 'Comment' }
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
               params: { likeable_id: post1.id, likeable_type: 'Post'  }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count decreases' do
        count = Like.count
        delete post_likes_destroy_post_path(post1),
               params: { likeable_id: post1.id, likeable_type: 'Post'  }
        expect(Like.count).to be(count - 1)
      end

      it 'verifies posts like count decreases' do
        count = post1.likes.count
        delete post_likes_destroy_post_path(post1),
               params: { likeable_id: post1.id, likeable_type: 'Post'  }
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
               params: { likeable_id: comment.id, likeable_type: 'Comment' }
        expect(response).to have_http_status(:success)
      end

      it 'verifies like count decreases' do
        count = Like.count
        delete comment_likes_destroy_comment_path(comment),
               params: { likeable_id: comment.id, likeable_type: 'Comment' }
        expect(Like.count).to be(count - 1)
      end

      it 'verifies comments like count decreases' do
        count = comment.likes.count
        delete comment_likes_destroy_comment_path(comment),
               params: { likeable_id: comment.id, likeable_type: 'Comment' }
        expect(comment.likes.count).to be(count - 1)
      end
    end
  end
end
