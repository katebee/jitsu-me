class ClubsController < ApplicationController

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find(params[:id])
  end

  def new
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to clubs_path
    else
      render 'new'
    end
  end

  private
  def club_params
    params.require(:club).permit(:name, :website, :contact)
  end
end
