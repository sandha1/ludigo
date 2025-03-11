class ActivitiesController < ApplicationController
  
    def index
    @activities = Activity.all
  end
  
  def show
    @activity = Activity(params[:id])
  end

end
