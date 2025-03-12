class SimpleCalendar::BusinessWeekCalendar < SimpleCalendar::Calendar
  private

    def date_range
      beginning = start_date.beginning_of_week
      ending    = start_date.end_of_week - 2.day
      (beginning..ending).to_a
    end
end
