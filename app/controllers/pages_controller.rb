class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def planning
    selected_date = params.fetch(:start_date, DateTime.now).to_datetime.in_time_zone('Paris')

    @slots = current_user.slots.where(start_at: selected_date.beginning_of_day()..selected_date.end_of_day).order(:start_at)
    day_slots = [ selected_date.change({ hour: 8, min: 30 }), selected_date.change({ hour: 10 }), selected_date.change({ hour: 13, min: 30 }), selected_date.change({ hour: 15 })]

    if @slots.length < 4
      incomplete_dates = day_slots -  @slots.pluck(:start_at)

      incomplete_dates.each do |incomplete_date|
        Slot.create(start_at: incomplete_date, end_at: incomplete_date + 1.hour + 30.minutes, user: current_user)
      end
      @slots = current_user.slots.where(start_at: selected_date.beginning_of_day()..selected_date.end_of_day).order(:start_at)
    end

    @favorites = current_user.favorites
  end
end
