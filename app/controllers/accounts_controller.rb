class AccountsController < ApplicationController
  before_filter :require_login!
  before_filter :find_user

  def edit
  end

  def update
    @user.attributes = params[:user]

    if @user.save
      redirect_to edit_account_path, :notice => "Account Updated"
    else
      render :action => :edit
    end
  end


  protected

  def find_user
    @user = current_user
    authorize! :manage, @user
  end
end
