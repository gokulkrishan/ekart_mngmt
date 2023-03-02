class Api::V1::SessionsController < ApplicationController
   def create
      token = Session.create(token: SecureRandom.hex(13), expire_at: Time.now+2.minutes)
      render json: token, status: 200
   end
end
              
