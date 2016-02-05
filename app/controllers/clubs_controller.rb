class ClubsController < ApplicationController
  def create
    @club = Club.new(params[:club])

    @club.save
    redirect_to @club
  end
end
