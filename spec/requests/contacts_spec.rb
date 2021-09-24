# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  let(:user) { create(:user) }
  describe 'GET /user/contacts' do
    it '/user/contacts' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get '/user/contacts'
        expect(response).to be_successful
        expect(response.body).to include('Contacts List')
      end
    end
  end
end
