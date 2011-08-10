class AccountsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = params[:user]

    if @user.save
      redirect_to edit_account_path, :notice => "Account Updated"
    else
      render :action => :edit
    end
  end
end
