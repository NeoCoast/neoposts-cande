# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'GET #index' do
    let!(:user) { create :user, password: 'password' }
    let!(:users) { create_list(:user, 3) }
    let!(:headers) { user.create_new_auth_token.merge('ACCEPT' => 'application/json') }

    it 'with no token' do
      get api_v1_users_path
      expect(response).not_to have_http_status(:success)
    end

    context 'with valid token' do
      before do
        get api_v1_users_path, headers:
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'verify json matches wanted structure' do
        json_response = JSON.parse(response.body)
        expect(json_response[0].keys).to match_array(%w[id email nickname first_name last_name birthday])
      end

      it 'shows all users' do
        json = JSON.parse(response.body)
        expect(json.length).to eq(User.count)
      end

      it 'shows all users' do
        User.all.each do |user|
          expect(response.body).to include(user.nickname)
        end
      end
    end
  end
end
