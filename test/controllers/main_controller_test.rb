require 'test_helper'

class MainControllerTest < ActionController::TestCase
	test "should get index" do
		get :index
		assert_response :success
	end

	#test "should get dash" do
		#get :dash
		#assert_response :success
	#end

	test "should get join" do
		get :join, id: 'not a code'
		assert_response :success
	end

end
