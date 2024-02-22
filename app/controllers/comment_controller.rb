class CommentController < ApplicationController

    def create 
        @article = Article.find(params[:id])
        @comment = @article.comments.create(comment_params.merge(user_id: @current_user.id))
        render json: @comment, status: :created
    end

    def show_all  
        @article = Article.find(params[:id])
        render json: @article.comments.all, status: :ok
    end

    def update 
        @comment = Comment.find(params[:id])
        if @comment.user_id == @current_user.id
            if @comment.update(comment_params)
                render json: @comment, status: :ok
            else 
                render json: {error: @comment.errors.full_messages}, status: :unprocessable_entity
            end
        else 
            render json: {error: "Not authorized to edit this comment"}, status: :unauthorized
        end
    end

    def destroy 
        @comment = Comment.find(params[:id])
        if @comment.user_id == @current_user.id
            @comment.destroy
            render json: {message: "Comment deleted"}, status: :ok
        else
            render json: {error: "Not authorized to delete this comment"}, status: :unauthorized
        end
    end

    private 
    def comment_params
        params.require(:comment).permit(:body)
    end
end
