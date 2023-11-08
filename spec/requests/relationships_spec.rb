# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'follow user' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:follower) { create :user }
    let(:followed) { create :user }

    before do
      follower.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      followed.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      sign_in follower
    end

    it 'verifies response is success' do
      post relationships_path, params: { relationship: { followed_id: followed.id } }
      expect(response).to have_http_status(:success)
    end

    it 'verifies relationship count increases' do
      count = Relationship.count
      post relationships_path, params: { relationship: { followed_id: followed.id } }
      expect(Relationship.count).to be(count + 1)
    end

    it 'verifies follower follows the followed' do
      post relationships_path, params: { relationship: { followed_id: followed.id } }
      expect(follower.following?(followed)).to be_truthy
    end

    it 'verifies cant follow same user twice' do
      post relationships_path, params: { relationship: { followed_id: followed.id } }
      post relationships_path, params: { relationship: { followed_id: followed.id } }
      expect(response).not_to have_http_status(:success)
    end
  end

  describe 'unfollow user' do
    image_path = File.join(File.dirname(__FILE__), '..', 'images', 'download.jpeg')
    let(:follower) { create :user }
    let(:followed) { create :user }
    let(:relationship) { create :relationship, follower:, followed: }

    before do
      follower.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      followed.avatar.attach(io: File.open(image_path), filename: 'download.jpeg', content_type: 'image/jpeg')
      sign_in follower
      relationship
    end

    it 'verifies response is success' do
      delete relationship_path(followed.id), params: { relationship: { followed_id: followed.id } }
      expect(response).to have_http_status(:success)
    end

    it 'verifies relationship count decreases' do
      count = Relationship.count
      delete relationship_path(followed.id), params: { relationship: { followed_id: followed.id } }
      expect(Relationship.count).to be(count - 1)
    end

    it 'verifies follower does not follow the followes' do
      expect(follower.following?(followed)).to be_truthy
      delete relationship_path(followed.id), params: { relationship: { followed_id: followed.id } }
      expect(follower.following?(followed)).to be_falsey
    end

    it 'verifies cant unfollow same user twice' do
      delete relationship_path(followed.id), params: { relationship: { followed_id: followed.id } }
      count = Relationship.count
      delete relationship_path(followed.id), params: { relationship: { followed_id: followed.id } }
      expect(Relationship.count).to be(count)
    end
  end
end
