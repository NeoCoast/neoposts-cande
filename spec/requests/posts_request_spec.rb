# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  # include Devise::Test::ControllerHelpers
  include Devise::Test::IntegrationHelpers

  before do
    user = FactoryBot.create :user
    sign_in user
  end

  new_post = FactoryBot.attributes_for :post

  it 'creates a Post and redirects to show the post' do
    post '/posts', params: { post: { title: new_post[:title], body: new_post[:body] } }
    expect(response).to redirect_to(post_path(Post.last))
  end
end
