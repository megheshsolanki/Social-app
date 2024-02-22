class ApplicationController < ActionController::API
    before_action :authenticate_request
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


    include JsonWebToken
    def record_not_found
      render json: {error: "Entity not found"}, status: :not_found
    end
    
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
