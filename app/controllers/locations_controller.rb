class LocationsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all

    respond_to do |format|
      format.html
      format.json { render json: @locations }
    end
  end

end
