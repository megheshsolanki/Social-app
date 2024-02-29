class ForgotPasswordController < ApplicationController
    skip_before_action :authenticate_request 
    def create 
        @user = User.find_by(email: params[:email])
        if @user
            @user.generate_otp
            if @user.save
              ForgotPasswordMailer.with(user_id: @user.id).forgot_password.deliver_now
              render json: {message: "OTP sent" }
            else
              render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: { error: "Email address not found." }, status: :not_found
        end
    end

    def update
        @user = User.find_by(otp: params[:otp])
        if @user && @user.otp_sent_at >= 2.hours.ago
          if @user.update(password: params[:password])
            render json: { message: "Password reset successful." }
          else
            render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: "Invalid or expired OTP." }, status: :unprocessable_entity
        end
    end
      
end
