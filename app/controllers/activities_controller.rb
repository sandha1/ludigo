class ActivitiesController < ApplicationController

  # def index
  #   @activities = Activity.all

  #   if params[:query].present?
  #     @activities = @activities.search_by_name_and_description(params[:query])
  #   end

  #   if params[:setting].present?
  #     @activities = @activities.where(setting: params[:setting])
  #   end
  # end

  def index
    @activities = Activity.all
    @settings = Activity.distinct.pluck(:setting)

    if params[:query].present?
      @activities = @activities.search_by_name_and_description(params[:query])
    end

    if params[:setting].present?
      @activities = @activities.where(setting: params[:setting])
    end
  end

  def toggle
    @activity = Activity.find(params[:activity_id])
    @favorite = current_user.favorites.find_by(activity: @activity)

    if @favorite
      @favorite.destroy
    else
      @favorite = current_user.favorites.create(activity: @activity)
    end
    redirect_to activities_path
  end


  def show
    @activity = Activity.find(params[:id])
  end

  # def create
  #   raise
  # end

  def set_to_favorite
    @activity = Activity.find(params[:id])
    @activity.favorite = true
    @activity.save
    redirect_to activities_path

    if @activity.favorite.user == true
    end
  end

end
