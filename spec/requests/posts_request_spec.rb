# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  include Devise::Test::IntegrationHelpers

  describe '#create_post_request' do
    new_post = FactoryBot.attributes_for(:post)
    image_path = File.join(File.dirname(__FILE__), 'default.webp')
    before do
      user = FactoryBot.create :user
      user.avatar.attach(io: File.open(image_path), filename: 'default.webp', content_type: 'image/webp')
      sign_in user
    end

    it 'creates a Post and redirects to show the post' do
      post '/posts', params: { post: new_post }
      expect(response).to redirect_to(post_path(Post.last))
    end
  end
end
