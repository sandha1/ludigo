class SlotsController < ApplicationController

  def update
    @slot = Slot.find(params[:id])
    @slot.activity = Activity.find(params[:activity_id])
    @slot.save
    redirect_to planning_path
  end
end
