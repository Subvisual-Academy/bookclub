class SessionsController < ApplicationController
  def new; end

  def create
    if login(params[:name], params[:password])
      redirect_back_or_to root_path
    else
      flash.now[:warning] = "E-mail and/or password is incorrect."
      render "new"
    end
  end

  def destroy
    logout
    flash[:success] = "See you!"
    redirect_to log_in_path
  end
end
