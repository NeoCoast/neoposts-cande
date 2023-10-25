# frozen_string_literal: true

RSpec.describe 'Posts', type: :request do
  include Devise::Test::IntegrationHelpers

  describe '#create_post_request' do
    let(:new_post) { attributes_for :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
    let(:user) { create :user }

    it 'with no logged user - redirects to login' do
      post posts_path, params: { post: new_post }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'default.webp', content_type: 'image/webp')
        sign_in user
      end

      context 'creates post' do
        before do
          post posts_path, params: { post: new_post }
        end

        it 'redirects to show the post' do
          expect(response).to redirect_to(post_path(Post.last))
        end

        it 'verifies response is success' do
          expect(response).to have_http_status(:found)
        end

        it 'verifies post count increases' do
          count = Post.count
          post posts_path, params: { post: new_post }
          expect(Post.count).to be(count + 1)
        end
      end

      context 'does not create post' do
        it 'does not create post- missing body' do
          post posts_path, params: { post: { title: 'title', body: '' } }
          expect(response).to render_template('new')
        end

        it 'does not increase post count- missing body' do
          count = Post.count
          post posts_path, params: { post: { title: 'title', body: '' } }
          expect(Post.count).to be(count)
        end

        it 'does not create post- missing title' do
          post posts_path, params: { post: { title: '', body: 'body' } }
          expect(response).to render_template('new')
        end

        it 'does not increase post count- missing title' do
          count = Post.count
          post posts_path, params: { post: { title: '', body: 'body' } }
          expect(Post.count).to be(count)
        end
      end
    end
  end

  describe '#show_post_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
    let(:user) { create :user }
    let(:post) { create :post }

    it 'with no logged user - redirects to login' do
      get post_path(post)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'default.webp', content_type: 'image/webp')
        sign_in user
        get post_path(post)
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies lasts post body is correct' do
        expect(Post.last.body).to eq(post.body)
      end

      it 'verifies lasts post title is correct' do
        expect(Post.last.title).to eq(post.title)
      end
    end
  end

  describe '#index_post_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'default.webp')
    let(:user) { create :user }
    let(:post) { create :post }

    it 'with no logged user - redirects to login' do
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      let!(:posts) { create_list(:post, 6, user:) }
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'default.webp', content_type: 'image/webp')
        sign_in user
        get root_path
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies 6 posts are shown' do
        posts.each do |post|
          expect(response.body).to include(CGI.escapeHTML(post.title))
        end
      end

      it 'verifies only 6 posts are created' do
        post_titles = posts.map { |post| CGI.escapeHTML(post.title) }
        expect(response.body.scan(/#{Regexp.union(post_titles)}/).size).to eq(6)
      end
    end
  end
end
