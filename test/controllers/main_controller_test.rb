require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get dash" do
    get :dash
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get recruit" do
    get :recruit
    assert_response :success
  end

end
