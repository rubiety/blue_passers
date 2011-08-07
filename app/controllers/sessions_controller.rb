class SessionsController < ApplicationController
  def create  
    @user = User.initialize_with_omniauth(request.env["omniauth.auth"])

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, :notice => "Welcome #{@user}"
    else
      redirect_to root_path, :alert => @user.errors.full_messages
    end
  end

  def failure
  end
end
