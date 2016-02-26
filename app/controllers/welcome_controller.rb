class WelcomeController < ApplicationController

  def index
    @upcoming_events = upcoming_events.first(3)
  end

  private
    def upcoming_events
      events_today = Session.where("day_of_week = ? AND start_time > ?", Time.now.wday, Time.now.strftime("%H:%M:%S")).order(:start_time)
      events_tomorrow = Session.where("day_of_week = ?", Time.now.wday + 1).order(:start_time)
      upcoming_events = events_today + events_tomorrow
    end
end
