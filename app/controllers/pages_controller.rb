class PagesController < ApplicationController
  PAGES = ["help", "privacy"]

  def show
    if PAGES.include?(params[:id])
      render :action => params[:id]
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
