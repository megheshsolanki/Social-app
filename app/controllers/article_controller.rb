class ArticleController < ApplicationController

    def get_all
        @articles = []

        @articles += Article.where(user_id: @current_user.id)

        @articles += Article.where(privacy: 'public').where.not(user_id: @current_user.id)
        
        Article.where(privacy: 'friends').where.not(user_id: @current_user.id).select do |article|
            @friend = Friendship.find_by(sender_id: article.user_id, reciever_id: @current_user.id)
            if(@friend)
                @articles << article
            end
        end
        
        render json: {articles: @articles,size: @articles.size}, status: :ok
    end
    def index 
        @page = params[:page].to_i || 1
        @per_page = params[:page_size].to_i || 10 
        @articles = Article.limit(@per_page).offset((@page - 1) * @per_page)
        render json: @articles, status: :ok 
    end
    def create 
        @user = @current_user 
        @article = @user.articles.create(article_params)
        render json: @article, status: :created
    end

    def show 
        @article = Article.find(params[:id])
        render json: @article, status: :ok
    end

    def update 
        @article = Article.find(params[:id])
        if @article.user_id == @current_user.id 
            if @article.update(article_params)
                render json: @article, status: :ok
            else
                render json: {errors: @article.errors.full_messages}, status: :unprocessable_entity
            end
        else 
            render json: {errors: "Not authorized to edit this comment"}, status: :unauthorized
        end
    end

    def destroy 
        @article = Article.find(params[:id])
        if @article.user_id == @current_user.id 
            @article.destroy
            render json: {message: "article deleted" }, status: :no_content
        else 
            render json: {errors: "Not authorized to delete this article"}, status: :unauthorized
        end
    end


    private 
    def article_params
        params.require(:article).permit(:title, :body)
    end
end
