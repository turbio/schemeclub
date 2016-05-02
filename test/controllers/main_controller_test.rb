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

	test "join should show error message with not existant recruit code" do
		get :join, id: 'not a code'
		assert_response :success
		assert_select 'h1', 'no recruit code'
	end

	test "join should show error message with claimed recruit code" do
		get :join, id: recruit_codes(:claimed).code
		assert_response :success
		assert_select 'h1', 'recruit code claimed'
	end

	test "join should show error message with expired recruit code" do
		get :join, id: recruit_codes(:expired).code
		assert_response :success
		assert_select 'h1', 'recruit code expired'
	end

	test "should get join page with valid code" do
		get :join, id: recruit_codes(:available).code
		assert_response :success
		assert_select 'h1', 'Join the club'
	end
end
