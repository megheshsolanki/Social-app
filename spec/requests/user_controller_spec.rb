require 'rails_helper'

def json
  JSON.parse(response.body)
end

RSpec.describe "UserControllers", type: :request do
  
  let(:valid_params) { FactoryBot.attributes_for(:user) }
  let(:invalid_params) do 
    {
      name: "asd",
      email: "asdasd.com",
      phone_number: "123",
      password: "password"
    }
  end
  let(:user) { FactoryBot.create(:user)}
  let(:access_token) { JsonWebToken.jwt_encode(user_id: user.id) }
  describe "POST /register" do
    context "with valid parameters" do
      it "should return user instance" do
        post '/register', params: valid_params
        expect(json['user']).to be_present  
      end
      it 'returns the name' do
        post '/register', params: valid_params
        expect(json['user']['name']).to eq(valid_params[:name])  
      end
      it 'returns the email' do
        post '/register', params: valid_params
        expect(json['user']['email']).to eq(valid_params[:email])  
      end
      it 'returns the phone_number' do
        post '/register', params: valid_params
        expect(json['user']['phone_number']).to eq(valid_params[:phone_number])  
      end
      it 'returns a created status' do
        post '/register', params: valid_params
        expect(response).to have_http_status(:created)
      end
    end
    context "with invalid parameters" do
      it 'returns the errors' do
        post '/register', params: invalid_params
        expect(json['errors']).to be_present  
      end
      it 'returns a unproccessable content status' do
        post '/register', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "get /" do
    context "valid parameters" do
      it 'returns an array of users' do
        get "/", headers: { "Authorization" => "Bearer #{access_token}" }
        expect(json).to be_an_instance_of(Array)
      end
      it 'returns all the users' do
        get "/", headers: { "Authorization" => "Bearer #{access_token}" }
        expect(json.length).to eq(User.count-1)
      end
      it "returns ok status code" do
        get "/", headers: { "Authorization" => "Bearer #{access_token}" }
        expect(response).to have_http_status(:ok)
      end
    end
    context "invalid header" do 
      it "returns error" do
        get "/", headers: { "Authorization" => "someInvalidToken" }
        expect(json['error']).to be_present 
      end
      it "returns 401 status code" do
        get "/", headers: { "Authorization" => "someInvalidToken" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  describe "get /show" do
    context "valid headers" do
      it "returns the correct user" do
        get "/show", headers: { "Authorization" => "Bearer #{access_token}" }
        expect(json['email']).to eql(user.email)
      end
      it "returns ok status code" do
        get "/show", headers: { "Authorization" => "Bearer #{access_token}" }
        expect(response).to have_http_status(:ok)
      end
    end
    context "invalid authorization headers" do
      it "returns error" do
        get "/show", headers: { "Authorization" => "someInvalidToken" }
        expect(json['error']).to be_present
      end
      it "returns 401 status code" do
        get "/show", headers: { "Authorization" => "someInvalidToken" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "missing headers" do
      it "returns error" do
        get "/show"
        expect(json['error']).to eql("Authorization token missing")
      end
      it "returns 401 status code" do
        get "/show"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "patch /update" do
      let(:valid_params) do {name: Faker::Name.name} end
      let(:invalid_params) do {phone_number: "1234567"} end

      context "valid params" do
        it "returns the correct updated user" do
          patch "/update",params: valid_params, headers: { "Authorization" => "Bearer #{access_token}" }
          expect(json['email']).to eql(user.email)
        end
        it "returns the updated user's name" do
          patch "/update",params: valid_params, headers: { "Authorization" => "Bearer #{access_token}" }
          expect(json['name']).to eql(valid_params[:name])
        end
        it "returns ok status code" do
          patch "/update",params: valid_params, headers: { "Authorization" => "Bearer #{access_token}" }
          expect(response).to have_http_status(:ok)
        end
      end

      context "invalid params" do
        it "returns the errors array" do
          patch "/update",params: invalid_params, headers: { "Authorization" => "Bearer #{access_token}" }
          expect(json['errors']).to be_present
        end
        it "returns unproccessable content status code" do
          patch "/update",params: invalid_params, headers: { "Authorization" => "Bearer #{access_token}" }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
