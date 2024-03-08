class UserController < ApplicationController
    skip_before_action :authenticate_request,  only: [:create,:verify]
    def index 
        @users = User.where.not(id: @current_user.id)
        render json: @users, status: :ok
    end
    def create 
        @user = User.new(user_params.merge(verification: false))
        @user.profile_picture = upload_picture(params[:profile_picture]) if params[:profile_picture]
        @user.cover_picture = upload_picture(params[:cover_picture]) if params[:cover_picture]
        if @user.save
            token = jwt_encode({user_id: @user.id});
            verification_link = "http://localhost:3000/verification?token=#{token}"
            UserMailer.with(user_id: @user.id,verification_link: verification_link).account_verification.deliver_now
            render json: {user: @user}, status: :created
        else
            render json: {errors: @user.errors.full_messages} , status: :unprocessable_entity
        end
    end
    def verify 
        decoded = jwt_decode(params[:token])
        if decoded.present? && decoded.key?(:user_id)
            @user = User.find(decoded[:user_id])
            @user.verification = true
            if @user.save 
                render json: {user: @user, message: "user email verified"}, status: :ok 
            else
                render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: "invalid link"}, status: :unprocessable_entity
        end
    end
    def update 
        @user = @current_user
        if @user.update(user_params)
            @user.profile_picture = upload_picture(params[:profile_picture]) if params[:profile_picture]
            @user.cover_picture = upload_picture(params[:cover_picture]) if params[:cover_picture]
            @user.save 
            render json: @user , status: :ok
        else 
            render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
        end
    end


    def show 
        render json: @current_user, status: :ok
    end

    private

    def upload_picture(picture) 
        uploaded_picture = Cloudinary::Uploader.upload(picture)
        uploaded_picture['secure_url']
    end
    def user_params
        params.permit(:name, :password, :email, :phone_number,:otp, :otp_sent_at, :profile_picture, :cover_image);
    end
end
