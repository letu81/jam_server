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

ActiveRecord::Schema.define(version: 20160512201024) do

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

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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

  create_table "users", force: :cascade do |t|
    t.string   "email",          null: false
    t.string   "password",       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone_number"
    t.string   "type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
