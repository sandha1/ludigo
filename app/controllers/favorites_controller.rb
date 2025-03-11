class FavoritesController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_activity, only: [:create]

  def index
    @favorites = Favorite.where(user: current_user)
  end

  def create

    @favorite = Favorite.new
    @favorite.activity = Activity.find(params[:activity_id])
    @favorite.user = current_user
    
    if @favorite.save
      redirect_to favorites_path, notice: 'Activitée ajoutée avec succès!'
    else
      render :new
    end
  end

  # private

  # def set_activity
  #   @activity = Activity.find(params[:activity_id])
  # end

end
