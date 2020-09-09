class SessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]

  def new
    if current_user
      redirect_to(root_path)
    end

    @user = User.new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to root_path, notice: "Welcome, #{current_user.name}!"
    else
      flash[:alert] = "Incorrect email/password"
      redirect_to login_path, status: :unauthorized
    end
  end

  def destroy
    logout

    redirect_to(root_path, notice: "Logged out!")
  end
end
