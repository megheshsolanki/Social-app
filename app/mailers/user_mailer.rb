class UserMailer < ApplicationMailer
    def account_verification 
        @user = User.find(params[:user_id])
        @link = params[:verification_link]
        mail(to: @user.email, subject: "Verification Link");
    end
end
