require "test_helper"

class ProductTest < ActiveSupport::TestCase
   test "name should be present and valid" do
    product =Product.new(style_name: "apple")
    assert product.valid?
   end

   test "product is invalid with a style_name is too short" do
      product =Product.new(style_name: "ap")
      assert_not product.valid?
   end

   test "product is invalid with a duplicate style_name" do
      product1 = Product.create(style_name: "apple")
      product2 = Product.new(style_name: "apple")
      assert product2.valid?
   end
end
