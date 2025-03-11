class ActivitiesController < ApplicationController

    def index
    @activities = Activity.all
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def create
    raise
  end

  def set_to_favorite
    @activity = Activity.find(params[:id])
    @activity.favorite = true
    @activity.save
    redirect_to activities_path
  end

end
