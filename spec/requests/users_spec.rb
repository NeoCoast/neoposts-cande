# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#show_user_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }

    it 'with no logged user - redirects to login' do
      get user_show_path(user)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
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

  describe '#edit_user_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:modified_user) { attributes_for :user }

    it 'with no logged user - redirects to login' do
      get edit_user_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
        sign_in user
        get edit_user_registration_path, params: { user: modified_user }
      end

      it 'renders edit page' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update_user_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user, password: 'password' }
    let(:modified_user) { attributes_for :user }
    let(:user2) { create :user, password: 'password' }

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      sign_in user

      new_image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
      modified_user[:avatar] = fixture_file_upload(new_image_path, 'image/webp')
    end

    it 'redirects to user show page - wrong password' do
      put user_registration_path, params: { user: modified_user.merge(current_password: 'wrongpassword') }
      expect(response).to render_template('edit')
    end

    it 'redirects to user show page - used email' do
      put user_registration_path, params: { user: { email: user2.email } }
      expect(response).to render_template('edit')
    end

    it 'redirects to user show page - used nickname' do
      put user_registration_path, params: { user: { nickname: user2.email } }
      expect(response).to render_template('edit')
    end

    context 'updates user' do
      before do
        put user_registration_path, params: { user: modified_user.merge(current_password: 'password') }
      end

      it 'verifies updated email' do
        expect(user.reload.email).to eq(modified_user[:email])
      end

      it 'verifies updated nickname' do
        expect(user.reload.nickname).to eq(modified_user[:nickname])
      end

      it 'verifies updated last_name' do
        expect(user.reload.last_name).to eq(modified_user[:last_name])
      end

      it 'verifies updated first_name' do
        expect(user.reload.first_name).to eq(modified_user[:first_name])
      end

      it 'verifies updated birthday' do
        expect(user.reload.birthday).to eq(modified_user[:birthday])
      end

      it 'verifies updated avatar' do
        expect(user.reload.avatar.filename.to_s).to eq('default.webp')
      end
    end
  end
end
