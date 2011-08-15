class FlightsController < ApplicationController
  before_filter :find_flight, :except => [:index]

  def index
    @flights = Flight.all
  end

  def show
    @check_ins = @flight.check_ins
  end


  protected

  def find_flight
    @flight = Flight.find(params[:id])
  end
end
