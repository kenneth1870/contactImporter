require 'rails_helper'

RSpec.describe FailedRegister, type: :model do
    describe '#validations' do
    let(:failed_register) { build(:failed_register) }
    it 'test that factory object is valid' do
      expect(failed_register).to be_valid
    end
  end
end
