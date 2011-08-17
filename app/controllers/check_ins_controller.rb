class CheckInsController < ApplicationController
  before_filter :find_user
  before_filter :find_check_in, :except => [:index]


  def destroy
    @check_in.destroy
    redirect_to user_path(@user), :notice => "Flight has been removed from your history."
  end

  protected

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_check_in
    @check_in = @user.check_ins.find(params[:id])
  end
end
