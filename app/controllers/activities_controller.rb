class ActivitiesController < ApplicationController
  def show
    @activity = Activity(params[:id])
  end

  
end
