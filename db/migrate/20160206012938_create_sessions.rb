class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :title
      t.string :day_of_week
      t.string :start_time
      t.string :end_time
      t.string :location_lat
      t.string :location_lng
      t.text :description
      t.references :club, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
