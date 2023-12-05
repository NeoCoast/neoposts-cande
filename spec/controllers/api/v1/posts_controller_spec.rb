# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :request do
  describe 'GET #index' do
    let!(:user) { create :user, password: 'password' }
    let!(:post2) { create :post, user: }
    let!(:post3) { create :post, user: }
    let!(:other_user) { create :user, password: 'password' }
    let!(:other_post) { create :post, user: other_user }
    let!(:headers) { user.create_new_auth_token.merge('ACCEPT' => 'application/json') }

    it 'with no token' do
      get api_v1_user_posts_path(user.id)
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ errors: ['You need to sign in or sign up before continuing.'] }.to_json)
    end

    context 'with valid token' do
      before do
        get api_v1_user_posts_path(user.id), headers:
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'verify json matches wanted structure' do
        json_response = JSON.parse(response.body)
        expect(json_response[0].keys).to match_array(%w[id title body published_at user_id likes_count comments_count])
      end

      it 'shows correct amount of posts' do
        json = JSON.parse(response.body)
        expect(json.length).to eq(user.posts.count)
      end

      it 'shows all users posts' do
        user.posts.each do |post|
          expect(response.body).to include(post.title)
        end
      end

      it 'shows only users posts' do
        expect(response.body).not_to include(other_post.title)
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create :user, password: 'password' }
    let!(:post1) { create :post, user: }
    let(:commentable) { create :comment, user:, commentable: post1 }
    let(:comment) { create :comment, user:, commentable: }
    let(:comment2) { create :comment, user:, commentable: }
    let!(:headers) { user.create_new_auth_token.merge('ACCEPT' => 'application/json') }

    it 'with no token' do
      get api_v1_post_path(post1.id)
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ errors: ['You need to sign in or sign up before continuing.'] }.to_json)
    end

    it 'with invalid post id' do
      get(api_v1_post_path(0), headers:)
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq({ message: 'Post does not exist' }.to_json)
    end

    context 'with valid token' do
      before do
        user.likes.create(likeable: post1)
        get api_v1_post_path(post1.id), headers:
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'verify json matches wanted structure' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(%w[id title body published_at user_id comments likes])
      end

      it 'shows all posts comments' do
        post1.comments.each do |comment|
          expect(response.body).to include(comment.content)
        end
      end

      it 'shows comments comments' do
        commentable.comments.each do |comment|
          expect(response.body).to include(comment.content)
        end
      end
    end

    it 'shows all posts likes' do
      post1.likes.each do |like|
        expect(response.body).to include(like.user_id)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { create :user, password: 'password' }
    let!(:user2) { create :user, password: 'password' }
    let(:new_post) { attributes_for :post }
    let!(:headers) { user.create_new_auth_token.merge('ACCEPT' => 'application/json') }

    it 'with no token' do
      post api_v1_user_posts_path(user.id)
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ errors: ['You need to sign in or sign up before continuing.'] }.to_json)
    end

    it 'with invalid user id' do
      post(api_v1_user_posts_path(0), params: { post: new_post }, headers:)
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq({ message: 'User does not exist' }.to_json)
    end

    it 'with different user id than token' do
      post(api_v1_user_posts_path(user2.id), params: { post: new_post }, headers:)
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq({ message: 'Unauthorized' }.to_json)
    end

    context 'with valid token' do
      context 'with valid params' do
        let(:new_post) { attributes_for :post }
        before do
          post api_v1_user_posts_path(user.id), params: { post: new_post }, headers:
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'verifies post count increases' do
          count = Post.count
          post(api_v1_user_posts_path(user.id), params: { post: new_post }, headers:)
          expect(Post.count).to be(count + 1)
        end

        it 'verifies user post count increases' do
          count = user.posts.count
          post(api_v1_user_posts_path(user.id), params: { post: new_post }, headers:)
          expect(user.posts.count).to be(count + 1)
        end
      end

      context 'with empty body' do
        let(:post_params) { { post: { title: 'title', body: '' } } }

        it 'returns http bad request' do
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq({ errors: { body: ["can't be blank"] } }.to_json)
        end

        it 'verifies post count does not increase' do
          count = Post.count
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(Post.count).to be(count)
        end

        it 'verifies user post count does not increase' do
          count = user.posts.count
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(user.posts.count).to be(count)
        end
      end

      context 'with empty title' do
        let(:post_params) { { post: { title: '', body: 'body' } } }

        it 'returns http bad request' do
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq({ errors: { title: ["can't be blank"] } }.to_json)
        end

        it 'verifies post count does not increase' do
          count = Post.count
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(Post.count).to be(count)
        end

        it 'verifies user post count does not increase' do
          count = user.posts.count
          post(api_v1_user_posts_path(user.id), params: post_params, headers:)
          expect(user.posts.count).to be(count)
        end
      end
    end
  end
end
