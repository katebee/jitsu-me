class AddLatLngToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :location_lat, :string
    add_column :clubs, :location_lng, :string
    add_column :clubs, :postcode, :string
  end
end
