require "test_helper"

class CategoriesTest < ActionDispatch::IntegrationTest
  test "should create and show user" do
    # Create a new user
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      user = JSON.parse(response.body)
      assert_equal "Ajith",response.parsed_body["name"]
      assert_equal "ajith1@gmail.com",response.parsed_body["email"]

    # Log in user and generate token
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajith@12" }
      assert_response :success
      response_body = JSON.parse(response.body)
      token = response_body['token']
      expire_at = Time.now + 1.hour
      user.update(token: token, expire_at: expire_at)
    
    #index method
      get api_v1_categories_url, params: { token: token}
      assert_response :success
      category =JSON.parse(response.body)
      assert_not_empty categories

    # Create a product
      post api_v1_products_url, params: { product: { prd_type: "Mobile phones", style_name: "apple" }, token: token }
      assert_response :success
      product =JSON.parse(response.body)
      assert_equal "Mobile phones",response.parsed_body["prd_type"]
      assert_equal "apple",response.parsed_body["style_name"]

    # Create a category
      product =Product.last.id
      post api_v1_categories_url, params: { category: { colour: "black", price: 45000, qty: 5, product_id: product}, token: token }
      assert_response :success
      category =JSON.parse(response.body)
      assert_equal "black", response.parsed_body["colour"]
      assert_equal 45000, response.parsed_body["price"]
      assert_equal 5, response.parsed_body["qty"]

    # show a category
      category =Category.last
      get api_v1_category_url(category), params: { token: token }
      assert_response :success
      category =JSON.parse(response.body)
      assert_equal "black", response.parsed_body["colour"]
      assert_equal 45000, response.parsed_body["price"]
      assert_equal 5, response.parsed_body["qty"]

    # update a category
      category.update(colour: "black,blue")
      put api_v1_category_url(category), params: { token: token }
      assert_response :success
      response_body = JSON.parse(response.body)
      assert_equal  "category updated successfully", response.parsed_body["message"]

    # delete a category
      delete api_v1_category_url(category), params: { token: token }
      assert_response :success
      response_body = JSON.parse(response.body)
      assert_equal  "category has been deleted" , response.parsed_body["message"]
  end

  test "using invalid token" do
    # Create a new user
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      user = JSON.parse(response.body)
      assert_equal "Ajith",response.parsed_body["name"]
      assert_equal "ajith1@gmail.com",response.parsed_body["email"]

    # Log in user and generate token
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajith@12" }
      assert_response :success
      response_body = JSON.parse(response.body)
      token = response_body['token']
      expire_at = Time.now + 1.hour
      user.update(token: token, expire_at: expire_at)

    # index api with invalid token
      invalid_token = "invalid_token123"
      get api_v1_categories_url, params: { token: invalid_token}
      assert_response :unauthorized
      category =JSON.parse(response.body)
    
    # index api without token
      get api_v1_categories_url
      assert_response :unauthorized
      response_body = JSON.parse(response.body)
      assert_equal "Please login", response_body["error"]

    # login with invalid email
      post api_v1_login_url, params: { email: "ajith@gmail.com", password: "Ajith@12" }
      assert_response :unauthorized
      login =JSON.parse(response.body)
      assert_equal "Invalid email or password",response.parsed_body["error"]

     # login with invalid password
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajit@12" }
      assert_response :unauthorized
      login =JSON.parse(response.body)
      assert_equal "Invalid email or password",response.parsed_body["error"]   
  end
end
