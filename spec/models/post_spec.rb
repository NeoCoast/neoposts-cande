# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) do
    described_class.create(title: 'New post', body: 'New post body')
  end

  describe '#title' do
    subject(:title) { post.title }

    it 'returns title of the post' do
      expect(title).to eq('New post')
    end
  end

  describe '#body' do
    subject(:body) { post.body }

    it 'returns body of the post' do
      expect(body).to eq('New post body')
    end
  end

  describe 'presence validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
