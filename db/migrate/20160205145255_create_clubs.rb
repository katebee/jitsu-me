class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :website
      t.string :tjfurl
      t.string :contact
      t.string :location_lat
      t.string :location_lng
      t.string :postcode
      t.timestamps null: false
    end
  end
end
