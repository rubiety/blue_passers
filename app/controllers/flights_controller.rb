class FlightsController < ApplicationController
  def index
    @flight = Flight.all
  end
end
