class ClubsController < ApplicationController

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find(params[:id])
  end

  def new
    @club = Club.new
  end

  def edit
    @club = Club.find(params[:id])
  end

  def create
    @club = Club.new(club_params)

    if @club.save
      redirect_to clubs_path
    else
      render 'new'
    end
  end

  def update
    @club = Club.find(params[:id])

    if @club.update(club_params)
      redirect_to clubs_path
    else
      render 'edit'
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    redirect_to clubs_path
  end

  private
  def club_params
    params.require(:club).permit(:name, :website, :contact)
  end
end
