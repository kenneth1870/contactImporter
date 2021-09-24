# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FailedRegisters', type: :request do
   let(:user) { create(:user) }
  describe 'GET /user/imported_files' do
    it '/user/imported_files' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get '/user/imported_files'
        expect(response).to be_successful
        expect(response.body).to include('Uploaded file list')
      end
    end
  end
end
