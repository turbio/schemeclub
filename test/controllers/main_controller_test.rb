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

	test 'signup should only accept an alphanumeric name' do
		post :signup, :signup => {
			:code => recruit_codes(:available).code,
			:name => 'name with invalid characters^&*($#',
			:password => 'test'
		}

		assert_response :success
		assert_select 'ul' do
			assert_select 'li', 'Name must be alphanumeric'
		end
	end

	test 'signup should require a password' do
		post :signup, :signup => {
			:code => recruit_codes(:available).code,
			:name => 'validname'
		}

		assert_response :success
		assert_select 'ul' do
			assert_select 'li', 'Password can\'t be blank'
		end
	end

	test 'signup should require a name' do
		post :signup, :signup => {
			:code => recruit_codes(:available).code,
			:password => 'validpassword'
		}

		assert_response :success
		assert_select 'ul' do
			assert_select 'li', 'Name can\'t be blank'
		end
	end

	test 'signup should verify code when signing up' do
		#handle blank code field
		post :signup, :signup => {
			:name => 'test',
			:password => 'validpassword'
		}

		assert_response :success
		assert_select 'h1', 'no recruit code'

		#invalid code in field
		post :signup, :signup => {
			:name => 'test',
			:password => 'validpassword',
			:code => 'notavalidcode'
		}

		assert_response :success
		assert_select 'h1', 'no recruit code'

		#handle claimed code
		post :signup, :signup => {
			:name => 'test',
			:password => 'validpassword',
			:code => recruit_codes(:claimed).code
		}

		assert_response :success
		assert_select 'h1', 'recruit code claimed'

		#handle expired code
		post :signup, :signup => {
			:name => 'test',
			:password => 'validpassword',
			:code => recruit_codes(:expired).code
		}

		assert_response :success
		assert_select 'h1', 'recruit code expired'
	end

	test 'signup should make sure user with name doesn\'t already exist' do
		post :signup, :signup => {
			:name => 'root',
			:password => 'password',
			:code => recruit_codes(:available).code
		}

		assert_response :success
		assert_select 'ul', 'Name has already been taken'
	end

	test 'signup with valid data' do
		post :signup, :signup => {
			:name => 'test',
			:password => 'password',
			:code => recruit_codes(:available).code
		}

		assert_response :redirect
		assert_includes session, :user_id

		#verify that the user was created correctly
		@user = User.find(session[:user_id])
		assert @user.name == 'test', 'user name should be same as entered'
		assert @user.password != 'password', 'hashed password should not equal input password (probably)'

		#check parent/child status
		assert @user.parent.name == 'root', 'user parent should be root'
		assert @user.children.length == 0, 'should not have any children yet'

		assert @user.earned == 0, 'user should start with neutral balance'
		assert @user.transactions.length == 2, 'user should start with two transactions'

		assert @user.parent.earned == 10_00, 'parent should recieve all of roots income because root has no parent'
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

	test 'should get dash when logged in' do
		get :dash

		assert_response :success
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
