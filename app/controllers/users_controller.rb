class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @check_ins = @user.check_ins
    @airports = @user.airports
  end
end
