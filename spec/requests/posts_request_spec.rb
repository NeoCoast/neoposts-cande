# frozen_string_literal: true

RSpec.describe 'Posts', type: :request do
  include Devise::Test::IntegrationHelpers

  describe '#create_post_request' do
    let(:new_post) { attributes_for :post }
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }

    it 'with no logged user - redirects to login' do
      post posts_path, params: { post: new_post }
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
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
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:post) { create :post }

    it 'with no logged user - redirects to login' do
      get post_path(post)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
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
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }
    let(:user4) { create :user }

    it 'with no logged user - redirects to login' do
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      let!(:posts) { create_list(:post, 6, user: user2) }
      let!(:post3) { create :post, user: user3 }
      let!(:post4) { create :post, user: user4 }

      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
        sign_in user
        user.follow(user2)
        user.follow(user4)
        get root_path
      end

      it 'verifies response is success' do
        expect(response).to have_http_status(:success)
      end

      it 'verifies users2 6 posts are shown' do
        posts.each do |post|
          expect(response.body).to include(post.title)
        end
      end

      it 'verifies users4 post is shown' do
        expect(response.body).to include(post4.title)
      end

      it 'verifies only 7 posts are shown' do
        followed_posts = posts << post4
        post_titles = followed_posts.map { |post| CGI.escapeHTML(post.title) }
        expect(response.body.scan(/#{Regexp.union(post_titles)}/).size).to eq(7)
      end

      it 'verifies user3 post is not shown' do
        expect(response.body).not_to include(post3.title)
      end
    end
  end

  describe '#destroy_post_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:new_post) { create :post, user: }
    let(:commentable) { create :comment, user:, commentable: new_post }
    let(:comment) { create :comment, user:, commentable: }

    it 'with no logged user - redirects to login' do
      delete post_path(new_post)
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'with logged user' do
      before do
        user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
        sign_in user
        user.likes.create(likeable: new_post)
        user.likes.create(likeable: commentable)
        user.likes.create(likeable: comment)
      end

      it 'verifies response is success' do
        delete post_path(new_post)
        expect(response).to have_http_status(:success)
      end

      it 'verifies post count decreases' do
        count = Post.count
        delete post_path(new_post)
        expect(Post.count).to be(count - 1)
      end

      it 'verifies post likes count decreases' do
        count = Like.count
        delete post_path(new_post)
        expect(Like.count).to be(count - 3)
      end

      it 'verifies comment count decreases' do
        count = Comment.count
        delete post_path(new_post)
        expect(Comment.count).to be(count - 2)
      end

      it 'verifies user post count decreases' do
        count = user.posts.count
        delete post_path(new_post)
        expect(user.posts.count).to be(count - 1)
      end

      it 'verifies user comment count decreases' do
        count = user.comments.count
        delete post_path(new_post)
        expect(user.comments.count).to be(count - 2)
      end

      it 'verifies user like count decreases' do
        count = user.likes.count
        delete post_path(new_post)
        expect(user.likes.count).to be(count - 3)
      end
    end
  end

  describe '#sort_posts_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:user2) { create :user }

    let!(:post4) { create :post, user: user2 }
    let!(:post3) { create :post, user: user2 }
    let!(:post2) { create :post, user: user2 }

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      sign_in user
      user.likes.create(likeable: post2)
      user.likes.create(likeable: post4)
      user.follow(user2)
    end

    it 'shows posts in date order' do
      get root_path, params: { sort_by: '' }
      expect(response.body.index(post2.title)).to be < response.body.index(post3.title)
      expect(response.body.index(post2.title)).to be < response.body.index(post4.title)
    end

    it 'shows posts in liked order' do
      get root_path, params: { sort_by: 'Number of likes' }
      expect(response.body.index(post2.title)).to be < response.body.index(post3.title)
      expect(response.body.index(post4.title)).to be < response.body.index(post3.title)
    end

    it 'shows posts in trending' do
      get root_path, params: { sort_by: 'Trending' }
      expect(response.body.index(post2.title)).to be < response.body.index(post4.title)
      expect(response.body.index(post4.title)).to be < response.body.index(post3.title)
    end
  end

  describe '#filter_posts_request' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }

    let!(:post2) { create :post, user: user2, title: 'title2', body: 'body2' }
    let!(:post3) { create :post, user: user3, title: 'title3', body: 'body3' }

    before do
      user.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      post3.update(published_at: Time.now - 1.month)
      sign_in user
      user.follow(user2)
      user.follow(user3)
    end

    it 'filters posts by author' do
      get root_path, params: { author_filter: user2.nickname }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end

    it 'filters posts by title' do
      get root_path, params: { title_filter: post2.title }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end

    it 'filters posts by body' do
      get root_path, params: { body_filter: post2.body }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end

    it 'filters posts by date - day' do
      get root_path, params: { date_filter: 'Last day' }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end

    it 'filters posts by date - week' do
      get root_path, params: { date_filter: 'Last week' }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end

    it 'filters posts by date - month' do
      get root_path, params: { date_filter: 'Last month' }
      expect(response.body).to include(post2.title)
      expect(response.body).not_to include(post3.title)
    end
  end
end
