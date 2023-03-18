require "test_helper"

class ProductsTest < ActionDispatch::IntegrationTest
  test "should create and show user" do
    # Create a new user
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      user = JSON.parse(response.body)
      assert_equal "Ajith",response.parsed_body["name"]
      assert_equal "ajith1@gmail.com",response.parsed_body["email"]
      assert_equal "Ajith@12",response.parsed_body["password"]

    # Log in user and generate token
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajith@12" }
      assert_response :success
      response_body = JSON.parse(response.body)
      token = response_body['token']
      expire_at = Time.now + 1.hour
      user.update(token: token, expire_at: expire_at)
    
    # index method
      get api_v1_products_url, params: { token: token}
      assert_response :success
      product =JSON.parse(response.body)
      assert_not_empty product

    # Create a product
      post api_v1_products_url, params: { product: { prd_type: "Mobile phones", style_name: "apple" }, token: token }
      assert_response :success
      product =JSON.parse(response.body)
      assert_equal "Mobile phones",response.parsed_body["prd_type"]
      assert_equal "apple",response.parsed_body["style_name"]
    
    # update a product
      product =Product.last
      put api_v1_product_url(product), params: {token: token}
      product.update(style_name: "apple 13")
      assert_response :success
      product =JSON.parse(response.body)
      assert_equal "Product updated successfully", response.parsed_body["message"]

    #destroy a product
      delete api_v1_product_url(product), params: { token: token}
      assert_response :success
      product =JSON.parse(response.body)
      assert_equal "product destroyed", response.parsed_body["message"]

    # retrieving "style_name"  using joins
      product =Product.create(prd_type: "Mobile phones", style_name: "Apple")
      category =Category.create(colour: "black",price: 45000, qty: 5,product_id: product)
      get api_v1_joins_url, params: {token: token}
      assert_response :success
      product1 = JSON.parse(response.body)
      expected_response = Product.joins(:categories).all.select("products.id, products.style_name").map do |product|
        { "id" => product.id, "style_name" => product.style_name }
      end
      assert_equal expected_response, product1  

    # retreieving "like" api
      get api_v1_list_like_url, params: {search:"ap", token: token }
      assert_response :success
  end

  test "login and generate expired token" do
    # Create a new user
      post api_v1_users_url, params: { user: { name: "Ajith", email: "ajith1@gmail.com", password: "Ajith@12"} }
      assert_response :success
      user = JSON.parse(response.body)
      assert_equal "Ajith",response.parsed_body["name"]
      assert_equal "ajith1@gmail.com",response.parsed_body["email"]
      assert_equal "Ajith@12",response.parsed_body["password"]

    # Log in user and generate token
      post api_v1_login_url, params: { email: "ajith1@gmail.com", password: "Ajith@12" }
      assert_response :success
      response_body = JSON.parse(response.body)
      token = response_body['token']
      expire_at = Time.now - 1.hour
      user = User.find_by(email: "ajith1@gmail.com")
      user.update(token: token,expire_at: Time.now - 1.hour)

    # index api with expired token
      get api_v1_categories_url, params: { token: token}
      assert_response :unauthorized
      category =JSON.parse(response.body)
      assert_equal "Session expired. please login again",response.parsed_body["error"]
    end
end
