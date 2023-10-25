# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#show_user_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
    let(:user) { create :user }
    let(:post) { create :post }

    it 'with no logged user - redirects to login' do
      get user_show_path(user)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'default.webp', content_type: 'image/webp')
        sign_in user
        get user_show_path(user.nickname)
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies lasts user nickname is correct' do
        expect(User.last.nickname).to eq(user.nickname)
      end
    end
  end
end
