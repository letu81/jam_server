class CreateTruckVendor < ActiveRecord::Migration
  def change
    create_table :truck_vendors do |t|
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
      t.text    :description
      t.string  :facebook
      t.string  :hashtag
      t.string  :image
      t.string  :instagram
      t.string  :logo
      t.text    :menu
      t.string  :name
      t.string  :phone_number
      t.float   :price_score
      t.string  :primary_category
      t.float   :score
      t.string  :secondary_category
      t.string  :slug
      t.string  :twitter
      t.string  :url
      t.boolean :isFeatured
    end
  end
end
