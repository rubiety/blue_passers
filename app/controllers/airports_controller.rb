class AirportsController < ApplicationController
  before_filter :find_airport, :except => [:index]

  def index
    @airports = Airport.all
  end

  def show
  end


  protected

  def find_airport
    @airport = Airport.find(params[:id])
  end
end
