class SessionsController < ApplicationController
  def create
    @club = Club.find(params[:club_id])
    @session = @club.sessions.create(session_params)
    redirect_to club_path(@club)
  end

  private
    def session_params
      params.require(:session).permit(:day_of_week, :location_description)
    end
end
