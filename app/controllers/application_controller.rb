class ApplicationController < ActionController::API
    before_action :authenticate_request
    include JsonWebToken
    
    private 
    def authenticate_request 
        header = request.headers["Authorization"]
        if header.present? && header.split(" ").first == "Bearer"
            token = header.split(" ").last 
            decoded = jwt_decode(token)
            if decoded.present? && decoded.key?(:user_id)
                @current_user = User.find(decoded["user_id"])
            else 
                render json: {error: "Invalid Token"}, status: :unauthorized
            end
        else
            render json: {error: "Authorization token missing"}, status: :unauthorized
        end
    end
end
