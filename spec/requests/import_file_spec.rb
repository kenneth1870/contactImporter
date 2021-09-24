# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ImportFiles", type: :request do
  let(:user) { create(:user) }
  describe "GET /import" do
    it "redirect to the log_in page as a non logged in user" do
      get "/import"
      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response.body).to include("Log in")
    end

    it "returns a success response as a logged in user" do
      aggregate_failures do
        sign_in user
        get root_path
        expect(response).to be_successful
        get "/import"
        expect(response).to be_successful
        expect(response.body).to include("Upload Contacts")
      end
    end
  end
end
