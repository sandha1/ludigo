class SlotsController < ApplicationController

  def update
    @slot = Slot.find(params[:id])
    @slot.activity = Activity.find(params[:activity_id])
    @slot.save
    redirect_to planning_path(start_date: @slot.start_at.to_date)
  end

  def reset
    @slot = Slot.find(params[:id])
    @slot.update(activity_id: nil)
    redirect_to planning_path(start_date: @slot.start_at.to_date)
  end
end
