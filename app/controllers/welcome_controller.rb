class WelcomeController < ApplicationController

  def index
    @upcoming_events = upcoming_events.first(3)
  end

  private
    def upcoming_events
      events_today = Session.where('day_of_week = ? AND start_time > ?', Time.now.wday, Time.now.strftime('%H:%M:%S')).order(:start_time)
      events_tomorrow = Session.where('day_of_week = ?', tomorrow_modifier).order(:start_time)
      upcoming_events = events_today + events_tomorrow
    end

    def tomorrow_modifier
      # wday returns a int from 0 to 6, saturday needs to return 0, not 7
      if Time.now.wday == 6
        return Time.now.wday - 6
      else
        return Time.now.wday + 1
      end
    end
end
