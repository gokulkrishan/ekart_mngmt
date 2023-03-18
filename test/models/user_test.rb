require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user is valid with all required attributes" do
    user = User.new(
      name: "Gokul",
      email: "gokul@gmail.com",
      password: "Abc@12345"
    )
    assert user.valid?
  end

  test "user is invalid without a name" do
    user = User.new(
      email: "gokul1@gmail.com",
      password: "Abc12345"
    )
    assert_not user.valid?
  end

  test "user is invalid with a invalid password" do
    user = User.new(
      name: "gokul",
      email: "gokul1@gmail.com",
      password: "Gokul@123"
    )
    assert user.valid?
  end

  test "user is invalid with a password that is too short" do
    user = User.new(
      name: "arthi",
      email: "arthi1@gmail.com",
      password: "A2345"
    )
    assert_not user.valid?
  end

  test "user is invalid without a valid email" do
    user =User.new(
      name: "aswin",
      email: "aswin1@gmail.com",
      password: "Aswin@12"
    )
    assert user.valid?
  end

end
