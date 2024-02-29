class ForgotPasswordMailer < ApplicationMailer
    def forgot_password 
        @user = User.find(params[:user_id])
        @otp = @user.otp
        mail(to: @user.email, subject: "Password Reset Link");
    end
end
