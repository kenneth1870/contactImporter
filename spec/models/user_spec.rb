require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    let(:user) { build(:user) }
    it 'test that factory object is valid' do
      expect(user).to be_valid
    end

    it 'test that factory email sequence is valid' do
      user.save
      second_user = build(:user)
      expect(second_user).to be_valid
    end
  end
end
