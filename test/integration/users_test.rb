require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest

  test "should create and show user" do
    # index api
      get api_v1_users_url
      assert_response :success
      user =JSON.parse(response.body)
      assert_not_empty user

    # Create a new user
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      user1 = JSON.parse(response.body)
      assert_equal "Ajith", user1["name"]
      assert_equal "ajith1@gmail.com", user1["email"]
      assert_equal "Ajith@12", user1["password"]

    # Retrieve the created user
      user = User.last
      get api_v1_user_url(user)
      assert_response :success
      user2 = JSON.parse(response.body)
      assert_equal "Ajith", user2["name"]
      assert_equal "ajith1@gmail.com", user2["email"]
      assert_equal "Ajith@12", user2["password"]

    # Update the users name
      user.update(name: "Ajith kumar")
      put api_v1_user_url(user)
      assert_response :success
      user3 = JSON.parse(response.body)
      assert_equal "User updated", response.parsed_body["message"]

    # destroy the user
      delete api_v1_user_url(user)
      assert_response :success
      user = JSON.parse(response.body)
      assert_equal "User deleted" , response.parsed_body["message"]

  end

  test "Send a POST request to the forgot password endpoint" do
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      response_body = JSON.parse(response.body)

    # Log in user and generate token  
      user =User.last
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajith@12" }
      assert_response :success
      response_body = JSON.parse(response.body)
      token = response_body['token']
      expire_at = Time.now + 1.hour
      user.update(token: token, expire_at: expire_at)

    # Send a POST request to the "forgot password" endpoint
      post api_v1_forget_password_url(user), params: { email: user.email}
      assert_response :success
      response_body = JSON.parse(response.body)
      token = SecureRandom.hex(13)
      expire_at = Time.now + 1.hour
      user = User.find_by(email: "ajith1@gmail.com")
      user.update(token: token,expire_at: Time.now + 1.hour)
      
    # reset password using token
      post api_v1_reset_password_url, params: {  token: token }
      user.update(password: "Ajith#123")
      assert_response :success
      assert_equal "Your password has been reset successfully",response.parsed_body["message"]

    # logging out
      post api_v1_logout_url, params: { token: token }
      assert_response :success

    # Verify that the user's token has been removed from the database
      user.update(token: nil,expire_at: nil)
      assert_response :success
      user =JSON.parse(response.body)
      assert_equal "logged out",response.parsed_body["message"]
  end  
end
