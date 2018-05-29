require 'rails_helper'

describe Api::UsersController do
  describe "GET show" do
    let(:user1) { Fabricate(:user, id: '1') }

    it "responds with a 200 status" do
      get :show, params: { id: user1.id }, format: :json
      expect(response.status).to eq(200)
    end
  end
end
