class ActivitiesController < ApplicationController

  def index
    @activities = Activity.left_joins(:photo_attachment).order('active_storage_attachments.id ASC')

    # raise
    @settings = Activity.distinct.pluck(:setting)
    @age_ranges = Activity::AGE_RANGES.keys

    if params[:query] || params[:setting] || params[:minimum_age]
      @activities = Activity.search_with_filters(@activities, {query: params[:query], setting: params[:setting], minimum_age: params[:minimum_age]})
    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def show
    @activity = Activity.find(params[:id])
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
