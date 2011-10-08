class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @check_ins = @user.check_ins
    @airports = @user.airports

    # TODO: This should probably be counter-cached
    @airport_checkins = @airports.inject({}) do |checkins, airport|
      checkins[airport.id] = @check_ins.to_airport(airport).count
      checkins
    end
  end
end
