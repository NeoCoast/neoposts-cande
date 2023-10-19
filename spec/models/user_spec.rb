# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    described_class.create(email: 'buffy@gmail.com', nickname: 'Buff', first_name: 'Buffy', last_name: 'Summers',
                           birthday: Date.new(2000, 12, 12), password: 'passsword')
  end

  describe '#email' do
    subject(:email) { user.email }

    it 'returns email of the user' do
      expect(email).to eq('buffy@gmail.com')
    end
  end

  describe '#nickname' do
    subject(:nickname) { user.nickname }

    it 'returns nick name of the user' do
      expect(nickname).to eq('Buff')
    end
  end

  describe '#first_name' do
    subject(:first_name) { user.first_name }

    it 'returns first name of the user' do
      expect(first_name).to eq('Buffy')
    end
  end

  describe '#last_name' do
    subject(:last_name) { user.last_name }

    it 'returns last name of the user' do
      expect(last_name).to eq('Summers')
    end
  end

  describe '#birthday' do
    subject(:birthday) { user.birthday }

    it 'returns birthday of the user' do
      expect(birthday).to eq(Date.new(2000, 12, 12))
    end
  end

  describe '#password' do
    subject(:password) { user.password }

    it 'returns passsword of the user' do
      expect(password).to eq('passsword')
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:birthday) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:nickname).case_insensitive }
  end
end
