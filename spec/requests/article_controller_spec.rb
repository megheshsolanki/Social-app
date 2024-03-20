require 'rails_helper'
def json
  JSON.parse(response.body)
end
RSpec.describe "ArticleControllers", type: :request do
  
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:access_token1) { JsonWebToken.jwt_encode(user_id: user1.id) }
  let(:access_token2) { JsonWebToken.jwt_encode(user_id: user2.id) }
  let(:article) { FactoryBot.create(:article, user: user1) }
  let(:valid_params) { FactoryBot.attributes_for(:article) }
  let(:invalid_params) { FactoryBot.attributes_for(:article,title: "") }


  describe "POST /article" do
    context "with valid parameters" do
      it "should return the created article with correct title" do
        article_params = { article: valid_params}
        post "/article", params: article_params, headers: {
          "Authorization" => "Bearer #{access_token1}"
        }
        expect(json["title"]).to eq(valid_params[:title])  
      end
      it "should return created status code" do
        article_params = { article: valid_params}
        post "/article", params: article_params, headers: {
          "Authorization" => "Bearer #{access_token1}"
        }
        expect(response).to have_http_status(:created)
      end
    end
    context "with invalid parameters" do 
      it "should return the errors" do 
        article_params = { article: invalid_params}
        post "/article", params: article_params, headers: {
          "Authorization" => "Bearer #{access_token1}"
        }
        expect(json["errors"]).not_to be_empty
      end
      it "should return unproccessable content status code" do
        article_params = { article: invalid_params}
        post "/article", params: article_params, headers: {
          "Authorization" => "Bearer #{access_token1}"
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /article/:id" do
    context "with valid params" do
      it "should return the article" do
        get "/article/#{article.id}",headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(json["title"]).to eq(article.title)
      end
      it "should return ok status code" do
        get "/article/#{article.id}",headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(response).to have_http_status(:ok)
      end
    end
  end
  describe "PATCH /article/:id" do
    context "with valid parameters" do 
      it "should return the updated article with correct title" do
        article_params = valid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(json["title"]).to eql(valid_params[:title]) 
      end
      it "should return the updated article with correct body" do
        article_params = valid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(json["body"]).to eql(valid_params[:body]) 
      end
      it "should return ok status code" do
        article_params = valid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(response).to have_http_status(:ok) 
      end
    end
    context "with invalid parameters" do 
      it "should return the errors" do
        article_params = invalid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(json["errors"]).not_to be_empty  
      end
      it "should return unproccessable content status code" do
        article_params = invalid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token1}" }
        expect(response).to have_http_status(:unprocessable_entity) 
      end
    end
    context "when other user tries to update the article" do
      it "should return the errors" do
        article_params = valid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token2}" }
        expect(json["errors"]).not_to be_empty  
      end
      it "should return unauthorized status code" do
        article_params = valid_params
        patch "/article/#{article.id}", params: {article: article_params }, headers: { "Authorization" => "Bearer #{access_token2}" }
        expect(response).to have_http_status(:unauthorized)  
      end
    end
  end
  describe "DELETE /article/:id" do
    context "when correct user deletes article" do
      it "should delete the article" do
        delete "/article/#{article.id}", headers: { "Authorization" => "Bearer #{access_token1}"}
        expect(json["message"]).to eq("article deleted") 
      end
      it "should return no content status code" do
        delete "/article/#{article.id}", headers: { "Authorization" => "Bearer #{access_token1}"}
        expect(response).to have_http_status(:ok) 
      end
    end
    context "when other user tries to deletes article" do
      it "should return the errors" do
        delete "/article/#{article.id}", headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(json["errors"]).not_to be_empty
      end
      it "should return unauthorized status code" do
        delete "/article/#{article.id}", headers: { "Authorization" => "Bearer #{access_token2}"}
        expect(response).to have_http_status(:unauthorized) 
      end
    end
  end
end
