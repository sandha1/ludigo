class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def planning
    today = params.fetch(:start_date, DateTime.now).to_datetime
    # today = DateTime.now
    # @slots = Slot.where(starts_at: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    @slots = current_user.slots.where(start_at: today.beginning_of_day()..today.end_of_day)
  end
end
