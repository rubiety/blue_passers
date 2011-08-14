class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @flights = @user.flights
    @airports = @user.airports
  end
end
