class ApplicationController < ActionController::API
    def authenticate_request
        token = User.find_by(token: params[:token])
        if token.nil?
          render json: { error: 'Not Authorized' }, status: 401
        elsif !token.logged_in
          render json: { error: 'Please login' }, status: 401
        elsif token.expire_at < Time.now
          render json: { error: 'Session expired. please login again', expire_at: token.expire_at }, status: 401
        end
      end
end
