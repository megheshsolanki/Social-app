require 'rails_helper'

def json
  JSON.parse(response.body)
end

RSpec.describe "UserControllers", type: :request do
  describe "POST /register" do
    context "with valid parameters" do
      let!(:user) {FactoryBot.build(:user)}
      before do
        post '/register', params: {
            name: user.name,
            email: user.email,
            password: user.password,
            phone_number: user.phone_number
        }
      end
      it "should return user instance" do
        expect(json['user']).to be_present  
      end
      it 'returns the name' do
        expect(json['user']['name']).to eq(user.name)  
      end
      it 'returns the email' do
        expect(json['user']['email']).to eq(user.email)  
      end
      it 'returns the phone_number' do
        expect(json['user']['phone_number']).to eq(user.phone_number)  
      end
      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end
    context "with invalid parameters" do
      let(:user)  {FactoryBot.build(:user,{
        name: "asd",
        email: "asdasd.com",
        phone_number: "123",
        password: "password"
      })}
      before do
        post '/register', params: {
            name: user.name,
            email: user.email,
            password: user.password,
            phone_number: user.phone_number
        }
      end
      it 'returns the errors' do
        expect(json['errors']).to be_present  
      end
      it 'returns a unproccessable content status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "get /" do
    context "valid parameters" do
      let(:user) {FactoryBot.create(:user)}
      let(:access_token) { jwt_encode(user_id: user.id) }
        before do 
          post "/login", params: {
            email: user.email,
            password: user.password
          }
          access_token = json['access_token']
          get "/", headers: { "Authorization" => "Bearer #{access_token}" }
        end
        it 'returns an array of users' do
          expect(json).to be_an_instance_of(Array)
        end
        it 'returns all the users' do
            expect(json.length).to eq(User.count-1)
        end
        it "returns ok status code" do
          expect(response).to have_http_status(:ok)
        end
    end
    context "invalid header" do
        before do 
          get "/", headers: { "Authorization" => "someInvalidToken" }
        end
        it "returns error" do
          expect(json['error']).to be_present 
        end
        it "returns 401 status code" do
          expect(response).to have_http_status(:unauthorized)
        end
    end
  end
  describe "get /show" do
    context "valid headers" do
      let(:user) {FactoryBot.create(:user)}
      let(:access_token) { jwt_encode(user_id: user.id) }
        before do 
          post "/login", params: {
            email: user.email,
            password: user.password
          }
          access_token = json['access_token']
          get "/show", headers: { "Authorization" => "Bearer #{access_token}" }
        end
        it "returns the correct user" do
          expect(json['email']).to eql(user.email)
        end
        it "returns ok status code" do
          expect(response).to have_http_status(:ok)
        end
    end
    context "invalid headers" do
        before do 
          get "/show", headers: { "Authorization" => "someInvalidToken" }
        end
        it "returns error" do
          expect(json['error']).to be_present
        end
        it "returns 401 status code" do
          expect(response).to have_http_status(:unauthorized)
        end
    end
    context "invalid headers" do
        before do 
          get "/show"
        end
        it "returns error" do
          expect(json['error']).to eql("Authorization token missing")
        end
        it "returns 401 status code" do
          expect(response).to have_http_status(:unauthorized)
        end
    end

    describe "patch /update" do
      context "valid params" do
        let(:user) {FactoryBot.create(:user)}
        let(:access_token) { jwt_encode(user_id: user.id) }
        let(:updated_name) {Faker::Name.name}
          before do 
            post "/login", params: {
              email: user.email,
              password: user.password
            }
            access_token = json['access_token']
            patch "/update",params: {name: updated_name}, headers: { "Authorization" => "Bearer #{access_token}" }
          end
          it "returns the correct updated user" do
            expect(json['email']).to eql(user.email)
          end
          it "returns the updated user's name" do
            expect(json['name']).to eql(updated_name)
          end
          it "returns ok status code" do
            expect(response).to have_http_status(:ok)
          end
      end
      context "invalid params" do
        let(:user) {FactoryBot.create(:user)}
        let(:access_token) { jwt_encode(user_id: user.id) }
        let(:phone_number) {"1234567"}
          before do 
            post "/login", params: {
              email: user.email,
              password: user.password
            }
            access_token = json['access_token']
            patch "/update",params: {phone_number: phone_number}, headers: { "Authorization" => "Bearer #{access_token}" }
          end
          it "returns the errors array" do
            expect(json['errors']).to be_present
          end
          it "returns unproccessable content status code" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
      end
    end
  end
end
