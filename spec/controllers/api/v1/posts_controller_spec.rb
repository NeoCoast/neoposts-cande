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
      expect(response).not_to have_http_status(:success)
    end

    it 'with invalid user id' do
      get(api_v1_user_posts_path(0), headers:)
      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq({ message: 'User does not exist' }.to_json)
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
end
