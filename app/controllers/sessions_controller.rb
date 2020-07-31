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
      flash.now[:alert] = "E-mail and/or password is incorrect."

      render "new", status: :unauthorized
    end
  end

  def destroy
    logout

    redirect_to(root_path, notice: "Logged out!")
  end
end
