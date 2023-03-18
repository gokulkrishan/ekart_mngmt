class Api::V1::UsersController < ApplicationController
    def index
      users = User.all
      render json: users, status: 200
    end

    def show
      user =User.find_by(id: params[:id])
      if user
        render json: user, status:200
      else
        render json: "User not found", status: 404
      end
    end

    def create
      user = User.create(user_params)
      if user.save
        render json: user, status: 200
      else
        render json: user.errors.details, status: 422
      end
    end

    def update
      user = User.find_by(id: params[:id])
      if user
        user.update(name: params[:name],email: params[:email],password: params[:password])
        render json: { message: "User updated" }, status: 200 
      else
        render json: "User not found", status: 404
      end
    end

    def destroy
      user =User.find_by(id: params[:id])
      if user
        user.destroy
        render json: { message: "User deleted" }, status: 200
      else
        render json: "User not found", status: 404
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def login
      user = User.find_by(email: params[:email])
      if user && user.password == params[:password]
        user.update(token: SecureRandom.hex(13), expire_at: Time.now + 5.hours,logged_in: true)
        render json: { message: "Logged in", token: user.token }, status: 200
      else
        render json: { error: "Invalid email or password" }, status: 401
      end
    end

    def logout
      user =User.find_by(token: params[:token])
      if user
        user.update(logged_in: false)
        render json: { message: "logged out" },status: 200
      else
        render json: "Invalid email id", status: 401
      end 
    end
          
    def forget_password
      user = User.find_by(email: params[:email])
      if user
        user.update(token: SecureRandom.hex(13), expire_at: Time.now + 2.minutes)
        render json: { message: "Your new password has been sent to your email", token: user.token }, status: 200
      else
        render json:"Email address not found", status: 401
      end
    end

    def reset_password
      user = User.find_by(token: params[:token])
  
      if user && user.expire_at > Time.now
        user.update(password: params[:password])
        render json: { message: "Your password has been reset successfully" }, status: 200
      elsif user && user.expire_at < Time.now
        render json: { error: "Password reset token has expired" }, status: 401
      else
        render json: { error: "Invalid password reset token" }, status: 401
      end
    end
end
