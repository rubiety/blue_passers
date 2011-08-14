class AirportsController < ApplicationController
  before_filter :find_airport, :except => [:index]

  def index
    @airports = Airport.all
  end

  def show
    @check_ins = @airport.check_ins
    @flights_as_origin = @airport.flights_as_origin
    @flights_as_destination = @airport.flights_as_destination
  end


  protected

  def find_airport
    @airport = Airport.find(params[:id])
  end
end
