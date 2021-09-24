# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  describe 'GET /users/sign_in' do
    it 'returns a success response as a non logged in user' do
      get '/users/sign_in'
      expect(response).to be_successful
      expect(response.body).to include('Log in')
    end

    it 'redirect to root page as response as a logged in user' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get '/users/sign_in'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /users/sign_up' do
    it 'returns a success response as a non logged in user' do
      get '/users/sign_up'
      expect(response).to be_successful
      expect(response.body).to include('Sign up')
    end

    it 'redirect to root page as response as a logged in user' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get '/users/sign_up'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /users/edit' do
    it 'redirect to login page as response as a non logged in user' do
      get '/users/edit'
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns a success response as a logged in user' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get '/users/edit'
        expect(response).to be_successful
        expect(response.body).to include('Edit User')
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    it 'returns a success response as a logged in user' do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        delete '/users/sign_out'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
