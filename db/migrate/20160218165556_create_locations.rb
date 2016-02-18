class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :location_lat
      t.string :location_lng
      t.string :postcode
    end
  end
end
