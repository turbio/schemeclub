class DashController < ApplicationController
  def index
		return render 'index' if session[:user_id].nil?
		@user = User.find(session[:user_id])
		@code = RecruitCode.where(owner: @user.id).last || RecruitCode.new
  end
end
