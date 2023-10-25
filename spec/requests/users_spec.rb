# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#show_user_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
    let(:user) { create :user }

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

      let(:post) { create :post, user: }
      let(:post2) { create :post }

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies all user data is in the response' do
        expect(response.body).to include(user.first_name, user.last_name, user.nickname, user.email,
                                         user.birthday.strftime('%d/%m/%Y'), user.avatar.filename.to_s)
      end

      it 'verifies post count is in the response' do
        expect(response.body).to include(user.posts.count.to_s)
      end

      it 'verifies title of all posts are in the response' do
        user.posts.each do |post|
          expect(response.body).to include(post.title)
        end
      end

      it 'verifies title of other posts is not in the response' do
        expect(response.body).not_to include(post2.title)
      end

      it 'redirects to root if nickname is not the users' do
        get user_show_path('invalid_nickname')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
