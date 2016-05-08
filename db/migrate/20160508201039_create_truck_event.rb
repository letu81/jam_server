class CreateTruckEvent < ActiveRecord::Migration
  def change
    create_table :truck_events do |t|
      t.string  :day_of_week
      t.string  :end_time
      t.string  :latitude
      t.string  :longitude
      t.integer :neighborhood_id
      t.string  :start_time
      t.integer :vendor_id
      t.string  :metro
      t.string  :image
      t.string  :location
      t.text    :description
      t.string  :neighborhood
      t.string  :state
      t.string  :city
      t.string  :date_date
      t.string  :start_time_text
      t.string  :end_time_text
      t.string  :event
      t.string  :dateMD
      t.string  :hashtag
      t.boolean :hasFree
      t.boolean :hasEvent
      t.boolean :hasSpecial
      t.string  :landmark
      t.boolean :isFeatured
      t.string  :slug
      t.string  :truck_name
    end
  end
end
