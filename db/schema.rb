# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160508201044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "venue_id"
    t.text     "image"
    t.string   "category"
    t.string   "sub_category"
    t.float    "score"
    t.string   "seatgeek_url"
    t.string   "title"
    t.string   "short_title"
    t.boolean  "date_tbd"
    t.boolean  "time_tbd"
    t.datetime "datetime_local"
    t.boolean  "added_manually"
    t.string   "youtube"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "spotify"
    t.string   "soundcloud"
    t.string   "hashtag"
    t.string   "date"
    t.boolean  "isFree"
    t.string   "venue_name"
    t.string   "city"
    t.string   "state"
    t.string   "day"
    t.date     "announce_date"
    t.date     "date_date"
    t.boolean  "isFeatured"
    t.string   "age_limit"
    t.string   "price"
    t.string   "time"
    t.text     "description"
    t.text     "slug"
    t.string   "eventStatus"
    t.string   "address"
    t.string   "lat"
    t.string   "lon"
    t.text     "event_blurb"
    t.text     "venue_blurb"
    t.string   "dateMD"
    t.text     "web_description"
  end

  create_table "truck_events", force: :cascade do |t|
    t.string  "day_of_week"
    t.string  "end_time"
    t.string  "latitude"
    t.string  "longitude"
    t.integer "neighborhood_id"
    t.string  "start_time"
    t.integer "vendor_id"
    t.string  "metro"
    t.string  "image"
    t.string  "location"
    t.text    "description"
    t.string  "neighborhood"
    t.string  "state"
    t.string  "city"
    t.string  "date_date"
    t.string  "start_time_text"
    t.string  "end_time_text"
    t.string  "event"
    t.string  "dateMD"
    t.string  "hashtag"
    t.boolean "hasFree"
    t.boolean "hasEvent"
    t.boolean "hasSpecial"
    t.string  "landmark"
    t.boolean "isFeatured"
    t.string  "slug"
    t.string  "truck_name"
  end

  create_table "truck_vendors", force: :cascade do |t|
    t.string  "contact_name"
    t.string  "contact_email"
    t.string  "contact_phone"
    t.text    "description"
    t.string  "facebook"
    t.string  "hashtag"
    t.string  "image"
    t.string  "instagram"
    t.string  "logo"
    t.text    "menu"
    t.string  "name"
    t.string  "phone_number"
    t.float   "price_score"
    t.string  "primary_category"
    t.float   "score"
    t.string  "secondary_category"
    t.string  "slug"
    t.string  "twitter"
    t.string  "url"
    t.boolean "isFeatured"
  end

  create_table "venues", force: :cascade do |t|
    t.boolean "added_manually"
    t.string  "address"
    t.text    "blurb"
    t.string  "category"
    t.string  "city"
    t.string  "facebook"
    t.boolean "hasSpecial"
    t.string  "instagram"
    t.string  "image"
    t.boolean "isFeatured"
    t.string  "lat"
    t.string  "location"
    t.string  "lon"
    t.string  "logo"
    t.string  "metro"
    t.string  "name"
    t.string  "phone"
    t.string  "score"
    t.string  "slug"
    t.string  "state"
    t.string  "twitter"
    t.integer "venue_id"
    t.string  "website"
  end

end
