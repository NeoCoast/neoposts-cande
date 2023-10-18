# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  include Devise::Test::IntegrationHelpers

  before do
    user = FactoryBot.create :user
    sign_in user
  end

  new_post = FactoryBot.create :post
  new_post.published_at = Time.now

  describe '#time_since_pubication' do
    subject(:published_at) { post.published_at }

    it 'returns published_at of the post' do
      expect(time_since_publication(new_post)).to eq('0 minutes ago')
    end

    it 'returns published_at of the post' do
      new_post.published_at = 2.hour.ago
      expect(time_since_publication(new_post)).to eq('2 hours ago')
    end

    it 'returns published_at of the post' do
      new_post.published_at = 2.day.ago
      expect(time_since_publication(new_post)).to eq('2 days ago')
    end

    it 'returns published_at of the post' do
      new_post.published_at = 2.month.ago
      expect(time_since_publication(new_post)).to eq('2 months ago')
    end

    it 'returns published_at of the post' do
      new_post.published_at = 13.month.ago
      expect(time_since_publication(new_post)).to eq('1 years ago')
    end

    it 'returns published_at of the post' do
      new_post.published_at = 2.year.ago
      expect(time_since_publication(new_post)).to eq('2 years ago')
    end
  end
end
