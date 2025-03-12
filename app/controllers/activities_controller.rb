class ActivitiesController < ApplicationController

    def index
      if params[:query].present?
        @activities = Activity.search_by_name_and_description(params[:query])
      else
      @activities = Activity.all
      end
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

    if @activity.favorite.user == true
    end
  end

end
