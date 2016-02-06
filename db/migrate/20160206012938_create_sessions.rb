class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :day_of_week
      t.time :start_time
      t.time :end_time
      t.string :location_lat
      t.string :location_lng
      t.text :location_description
      t.references :club, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
