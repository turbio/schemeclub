require 'test_helper'

class MainControllerTest < ActionController::TestCase
	test 'should get index' do
		get :index
		assert_response :success
	end

	test 'should get index from dash if not logged in' do
		get :dash
		assert_select 'h1', 'Are you in the club?'
		assert_response :success
	end

	test 'join should show error message with not existant recruit code' do
		get :join, id: 'not a code'
		assert_response :success
		assert_select 'h1', 'no recruit code'
	end

	test 'join should show error message with claimed recruit code' do
		get :join, id: recruit_codes(:claimed).code
		assert_response :success
		assert_select 'h1', 'recruit code claimed'
	end

	test 'join should show error message with expired recruit code' do
		get :join, id: recruit_codes(:expired).code
		assert_response :success
		assert_select 'h1', 'recruit code expired'
	end

	test 'should get join page with valid code' do
		get :join, id: recruit_codes(:available).code
		assert_response :success
		assert_select 'h1', 'Join the club'
	end

	test 'login with correct credentials should set user_id in session and redirect' do

		post :login, :login => {
			:name => 'root',
			:password => 'root'
		}

		assert_response :redirect
		assert_includes session, :user_id

		#should have no errors (error messages stored in ul)
		assert_select 'ul', false
	end

	test 'login with incorrect credentials shows error and has no user_id session information' do

		post :login, :login => {
			:name => 'root',
			:password => 'incorrect password'
		}

		assert_response :success, 'should show index with errors when incorrect credentials'
		assert_not_includes session, :user_id, 'user id should not be in session on incorrect credentials'

		assert_select 'ul' do
			assert_select 'li', 'incorrect name or password'
		end

		post :login, :login => {

			:name => 'nonexistent user',
			:password => 'root'
		}

		assert_response :success, 'should show index with errors when incorrect credentials'
		assert_not_includes session, :user_id, 'user id should not be in session on incorrect credentials'

		assert_select 'ul' do
			assert_select 'li', 'incorrect name or password'
		end
	end
end
