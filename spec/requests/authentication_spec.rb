require 'rails_helper'
require 'jwt'
def json
  JSON.parse(response.body)
end

RSpec.describe "Authentications", type: :request do
  describe "POST /login" do
    context "with valid params" do
      let(:user) {FactoryBot.create(:user)}
      before do 
        post "/login", params: {
          email: user.email,
          password: user.password
        }
      end
      it "should return access token" do
        expect(json['access_token']).to be_present
      end
      it "should return refresh token" do
        expect(json['refresh_token']).to be_present
      end
      it "should return ok status" do
        expect(response).to have_http_status(:ok)  
      end
    end
    context "with invalid params" do
      let(:user) {FactoryBot.create(:user)}
        before do 
          post "/login", params: {
            email: user.email,
            password: "user.password"
          }
        end
        it "should return error" do
          expect(json['error']).to be_present
        end
        it "should return 401 status" do
          expect(response).to have_http_status(:unauthorized)  
        end
    end
  end
  describe "post /refresh" do
    context "valid parameters" do
      let(:user) {FactoryBot.create(:user)}
      let(:refresh_token) { jwt_encode(user_id: user.id) }
        before do 
          post "/login", params: {
            email: user.email,
            password: user.password
          }
          refresh_token = json['refresh_token']
          post "/refresh", params: {
            refresh_token: refresh_token
          }
        end
        it 'returns access_token' do
          expect(json['access_token']).to be_present
        end
        it "returns ok status code" do
          expect(response).to have_http_status(:ok)
        end
    end
  end
end
