class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.integer :venue_id
      t.text :image
      t.string :category
      t.string :sub_category
      t.float :score
      t.string :seatgeek_url
      t.string :title
      t.string :short_title
      t.boolean :date_tbd
      t.boolean :time_tbd
      t.datetime :datetime_local
      t.boolean :added_manually
      t.string :youtube
      t.string :facebook
      t.string :twitter
      t.string :spotify
      t.string :soundcloud
      t.string :hashtag
      t.string :date
      t.boolean :isFree
      t.string :venue_name
      t.string :city
      t.string :state
      t.string :day
      t.date :announce_date
      t.date :date_date
      t.boolean :isFeatured
      t.string :age_limit
      t.string :price
      t.string :time
      t.text :description
      t.text :slug
      t.string :eventStatus
      t.string :address
      t.string :lat
      t.string :lon
      t.text :event_blurb
      t.text :venue_blurb
      t.string :dateMD
      t.text :web_description
    end
  end
end
