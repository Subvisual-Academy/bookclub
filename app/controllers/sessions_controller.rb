class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to(root_path)
    end

    @user = User.new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to root_path
    else
      flash[:alert] = "Incorrect email/password"
      redirect_to log_in_path, status: :unauthorized
    end
  end

  def destroy
    logout

    redirect_to(root_path, notice: "Logged out!")
  end
end
