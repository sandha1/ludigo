class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:create]

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

  def check
    is_favorite = current_user.favorites.exists?(activity_id: params[:activity_id])
    render json: { is_favorite: is_favorite }
  end

  def toggle
    @activity = Activity.find(params[:activity_id])
    @favorite = current_user.favorites.find_by(activity: @activity)

    if @favorite
      @favorite.destroy
    else
      @favorite = current_user.favorites.create(activity: @activity)
    end
    
    redirect_to request.referer
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

end
