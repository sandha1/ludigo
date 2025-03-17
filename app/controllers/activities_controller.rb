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
    @max_duration = Activity.distinct.pluck(:max_duration)

    @age_ranges = {
      "3-6 ans" => (3..6),
      "6-10 ans" => (6..10),
      "+11 ans" => (11..Float::INFINITY)
    }

    @minimum_age = Activity.distinct.pluck(:minimum_age)


    if params[:query] || params[:setting] || params[:minimum_age] || params[:max_duration]
      @activities = Activity.search_with_filters(@activities, {query: params[:query], setting: params[:setting], minimum_age: params[:minimum_age], max_duration: params[:max_duration]})
    end
    # if params[:query].present?
    #   @activities = @activities.search_by_name_and_description(params[:query])
    # end

    # if params[:setting].present?
    #   @activities = @activities.where(setting: params[:setting])
    # end
    # @activities = @activities.where(minimum_age: params[:minimum_age]) if params[:minimum_age].present?
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
