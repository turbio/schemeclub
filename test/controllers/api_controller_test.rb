require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should post valid_name" do
    post :valid_name
    assert_response :success
  end

  test "should post valid_credentials" do
    post :valid_credentials
    assert_response :success
  end

end
