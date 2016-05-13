class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.boolean :added_manually
      t.string :address
      t.text :blurb
      t.string :category
      t.string :city
      t.string :facebook
      t.boolean :hasSpecial
      t.string :instagram
      t.string :image
      t.boolean :isFeatured
      t.string :lat
      t.string :location
      t.string :lon
      t.string :logo
      t.string :metro
      t.string :name
      t.string :phone
      t.string :score
      t.string :slug
      t.string :state
      t.string :twitter
      t.integer :venue_id
      t.string :website
    end
  end
end
