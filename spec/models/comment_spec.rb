# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) do
    described_class.create(content: 'New comment content')
  end

  describe '#content' do
    subject(:content) { comment.content }

    it 'returns content of the post' do
      expect(content).to eq('New comment content')
    end
  end

  describe 'presence validations' do
    it { should validate_presence_of(:content) }
  end
end
