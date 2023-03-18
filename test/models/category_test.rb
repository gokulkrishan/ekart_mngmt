require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  puts ActiveRecord::Base.connection_db_config.configuration_hash
  
  test "product and category should be valid" do
    product = Product.create(style_name: "apple")
    category = Category.new(product_id: product.id,price: 1, qty: 1)
    assert category.valid?
  end

  test "category is invalid with a price not greater than zero" do
    product = Product.create(style_name: "apple")
    category = Category.new(product_id: product.id,price: 0, qty: 1)
    assert_not category.valid?
  end
end

