class ActivitiesController < ApplicationController
  def show
    @activity = Activity(params[:id])
  end

  def index
    @activities = Activity.all
  end
end
