class UserController < ApplicationController
    skip_before_action :authenticate_request,  only: [:create]
    def index 
        @users = User.where.not(id: @current_user.id)
        render json: @users, status: :ok
    end
    def create 
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: {errors: @user.errors.full_messages} , status: :unprocessable_entity
        end
    end

    def update 
        @user = @current_user
        if @user.update(user_params)
            render json: @user , status: :ok
        else 
            render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
        end
    end


    def show 
        render json: @current_user
    end

    private
    def user_params
        params.require(:user).permit(:name, :password, :email, :phone_number,:otp, :otp_sent_at);
    end
end
