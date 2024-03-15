class ArticleController < ApplicationController

    def get_all
        @articles = []

        @articles += Article.where(user_id: @current_user.id)

        @articles += Article.where(privacy: 'public').where.not(user_id: @current_user.id)

        @blocked = BlockedUser.find_by(blocked_by: @current_user.id)
        @articles.reject {|article| @blocked.include? article.user_id} 
        
        Article.where(privacy: 'friends').where.not(user_id: @current_user.id).select do |article|
            @friend = Friendship.find_by(sender_id: article.user_id, reciever_id: @current_user.id)
            if(@friend)
                @articles << article
            end
        end

        render json: {size: @articles.size,articles: @articles}, status: :ok
    end
    def index 
        @page = params[:page].to_i || 1
        @per_page = params[:page_size].to_i || 10 
        @articles = Article.limit(@per_page).offset((@page - 1) * @per_page)
        render json: @articles, status: :ok 
    end
    def create 
        @user = @current_user 
        @article = @user.articles.build(article_params)
        if @article.save
            render json: @article, status: :created
        else 
            render json: {errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
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
            if @article.destroy
                render json: {message: "article deleted" }, status: :ok
            end
        else 
            render json: {errors: "Not authorized to delete this article"}, status: :unauthorized
        end
    end

    def share
        if SharedArticle.find_by(article_id: params[:id],shared_by_id: @current_user.id)
            render json: {message: "Article already shared"}, status: :ok 
        else
            @article = Article.find(params[:id])
            if @article.privacy == 'public' 
                @shared = SharedArticle.create(article_id: @article.id, shared_by_id: @current_user.id, owned_by_id: @article.user_id)
                render json: @shared, status: :created
            else 
                render json: {message: "Article is not public cannot be shared"}, status: :forbidden
            end
        end
    end

    private 
    def article_params
        params.require(:article).permit(:title, :body)
    end
end
