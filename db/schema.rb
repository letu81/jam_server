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

ActiveRecord::Schema.define(version: 20180112090534) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                   null: false
    t.string   "name",       limit: 255
    t.string   "mobile",     limit: 255,                 null: false
    t.string   "region",     limit: 255,                 null: false
    t.string   "address",    limit: 255,                 null: false
    t.boolean  "is_default",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "addresses", ["mobile"], name: "index_addresses_on_mobile", using: :btree
  add_index "addresses", ["user_id", "is_default"], name: "index_default_address_on_user_id", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "app_versions", force: :cascade do |t|
    t.integer  "code",          limit: 4,     default: 1, null: false
    t.string   "name",          limit: 255,               null: false
    t.integer  "mobile_system", limit: 4,                 null: false
    t.text     "content",       limit: 65535,             null: false
    t.datetime "created_at"
  end

  add_index "app_versions", ["code", "mobile_system"], name: "index_app_versions_on_code_and_mobile_system", unique: true, using: :btree
  add_index "app_versions", ["name", "mobile_system"], name: "index_app_versions_on_name_and_mobile_system", unique: true, using: :btree

  create_table "auth_codes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "mobile",     limit: 255
    t.boolean  "verified",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "c_type",     limit: 4
  end

  add_index "auth_codes", ["code"], name: "index_auth_codes_on_code", using: :btree
  add_index "auth_codes", ["mobile"], name: "index_auth_codes_on_mobile", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string  "name",          limit: 255,             null: false
    t.string  "identifier",    limit: 255,             null: false
    t.string  "sales_phone",   limit: 255
    t.string  "support_phone", limit: 255
    t.string  "full_name",     limit: 255,             null: false
    t.integer "status_id",     limit: 4,   default: 1, null: false
  end

  add_index "brands", ["identifier"], name: "index_brands_on_identifier", using: :btree
  add_index "brands", ["name"], name: "index_brands_on_name", using: :btree
  add_index "brands", ["status_id"], name: "index_brands_on_status_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "name",     limit: 255, null: false
    t.integer "position", limit: 4,   null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["position"], name: "index_categories_on_position", unique: true, using: :btree

  create_table "category_products", force: :cascade do |t|
    t.integer "category_id", limit: 4, null: false
    t.integer "product_id",  limit: 4, null: false
  end

  add_index "category_products", ["category_id", "product_id"], name: "index_category_products_on_cates_product", unique: true, using: :btree
  add_index "category_products", ["category_id"], name: "index_category_products_on_category_id", using: :btree
  add_index "category_products", ["product_id"], name: "index_category_products_on_product_id", using: :btree

  create_table "device_categories", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "device_categories", ["name"], name: "index_device_categories_on_name", using: :btree

  create_table "device_users", force: :cascade do |t|
    t.integer  "device_id",   limit: 4,   null: false
    t.integer  "device_type", limit: 4,   null: false
    t.integer  "device_num",  limit: 4,   null: false
    t.string   "name",        limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "device_users", ["device_id", "device_type", "device_num"], name: "index_device_users_on_type_and_num", unique: true, using: :btree
  add_index "device_users", ["device_id", "device_type"], name: "index_device_users_on_device_id_and_device_type", using: :btree
  add_index "device_users", ["device_id"], name: "index_device_users_on_device_id", using: :btree

  create_table "device_uuids", force: :cascade do |t|
    t.string   "uuid",               limit: 255
    t.string   "password",           limit: 255
    t.integer  "device_category_id", limit: 4,   default: 1, null: false
    t.integer  "kind_id",            limit: 4,               null: false
    t.integer  "status_id",          limit: 4,   default: 1, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "new_password",       limit: 255
    t.integer  "expirted_a",         limit: 4
    t.string   "access_token",       limit: 255
    t.integer  "expired_at",         limit: 4
    t.string   "device_mac",         limit: 255
  end

  add_index "device_uuids", ["access_token"], name: "index_device_uuids_on_access_token", using: :btree
  add_index "device_uuids", ["device_category_id"], name: "index_device_uuids_on_device_category_id", using: :btree
  add_index "device_uuids", ["device_mac"], name: "index_device_uuids_on_device_mac", using: :btree
  add_index "device_uuids", ["expired_at"], name: "index_device_uuids_on_expired_at", using: :btree
  add_index "device_uuids", ["kind_id"], name: "index_device_uuids_on_kind_id", using: :btree
  add_index "device_uuids", ["status_id"], name: "index_device_uuids_on_status_id", using: :btree
  add_index "device_uuids", ["uuid", "new_password"], name: "index_device_uuids_on_uuid_and_new_password", unique: true, using: :btree
  add_index "device_uuids", ["uuid", "password", "device_mac"], name: "index_device_uuids_on_uuid_pwd_mac", using: :btree
  add_index "device_uuids", ["uuid", "password"], name: "index_device_uuids_on_uuid_and_password", unique: true, using: :btree
  add_index "device_uuids", ["uuid", "status_id"], name: "index_device_uuids_on_uuid_and_status_id", using: :btree
  add_index "device_uuids", ["uuid"], name: "index_device_uuids_on_uuid", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "name",         limit: 255, default: "门锁",  null: false
    t.integer  "uuid",         limit: 4,                   null: false
    t.boolean  "is_online",                default: false, null: false
    t.integer  "status_id",    limit: 4,   default: 1,     null: false
    t.string   "mac",          limit: 255, default: ""
    t.datetime "activited_at"
    t.datetime "last_request"
    t.string   "monitor_sn",   limit: 255
    t.integer  "port",         limit: 4
    t.integer  "brand_id",     limit: 4,   default: 1,     null: false
    t.string   "pwd_setting",  limit: 255
  end

  add_index "devices", ["activited_at"], name: "index_devices_on_activited_at", using: :btree
  add_index "devices", ["brand_id", "activited_at"], name: "index_devices_on_brand_activited", using: :btree
  add_index "devices", ["brand_id"], name: "index_devices_on_brand_id", using: :btree
  add_index "devices", ["monitor_sn"], name: "index_devices_on_monitor_sn", using: :btree
  add_index "devices", ["name"], name: "index_devices_on_name", using: :btree
  add_index "devices", ["port"], name: "index_devices_on_port", using: :btree
  add_index "devices", ["pwd_setting"], name: "index_devices_on_pwd_setting", using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", unique: true, using: :btree

  create_table "districts", force: :cascade do |t|
    t.string   "code",            limit: 255,                 null: false
    t.string   "parent_code",     limit: 255
    t.string   "name",            limit: 255,                 null: false
    t.string   "pinyin",          limit: 255,                 null: false
    t.string   "abbr",            limit: 255,                 null: false
    t.string   "zip",             limit: 255
    t.integer  "level",           limit: 4
    t.boolean  "sensitive_areas",             default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "districts", ["abbr"], name: "index_districts_on_abbr", using: :btree
  add_index "districts", ["code"], name: "index_districts_on_code", unique: true, using: :btree
  add_index "districts", ["level"], name: "index_districts_on_level", using: :btree
  add_index "districts", ["parent_code"], name: "index_districts_on_parent_code", using: :btree
  add_index "districts", ["pinyin"], name: "index_districts_on_pinyin", using: :btree
  add_index "districts", ["sensitive_areas"], name: "index_districts_on_sensitive_areas", using: :btree
  add_index "districts", ["zip"], name: "index_districts_on_zip", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "content",    limit: 65535
    t.string   "contact",    limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "jam_services", force: :cascade do |t|
    t.integer  "user_id",      limit: 4,                   null: false
    t.integer  "service_type", limit: 4,   default: 1,     null: false
    t.string   "content",      limit: 255, default: "",    null: false
    t.boolean  "is_recall",                default: false, null: false
    t.datetime "created_at"
  end

  add_index "jam_services", ["is_recall"], name: "index_jam_services_on_is_recall", using: :btree
  add_index "jam_services", ["service_type", "is_recall"], name: "index_jam_services_on_service_type_and_is_recall", using: :btree
  add_index "jam_services", ["user_id"], name: "index_jam_services_on_user_id", using: :btree

  create_table "kinds", force: :cascade do |t|
    t.string  "name",      limit: 255,             null: false
    t.integer "brand_id",  limit: 4,               null: false
    t.integer "status_id", limit: 4,   default: 1, null: false
  end

  add_index "kinds", ["brand_id"], name: "index_kinds_on_brand_id", using: :btree
  add_index "kinds", ["name"], name: "index_kinds_on_name", using: :btree
  add_index "kinds", ["status_id"], name: "index_kinds_on_status_id", using: :btree

  create_table "locksmiths", force: :cascade do |t|
    t.string   "name",               limit: 255,                   null: false
    t.string   "phone",              limit: 255
    t.string   "mobile",             limit: 255
    t.string   "company",            limit: 255
    t.integer  "district_code",      limit: 4,                     null: false
    t.string   "qq",                 limit: 255
    t.string   "address",            limit: 255
    t.string   "certificate_number", limit: 255
    t.string   "avatar",             limit: 255
    t.boolean  "is_verified",                      default: false, null: false
    t.text     "company_info",       limit: 65535
    t.text     "company_service",    limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "locksmiths", ["certificate_number", "is_verified"], name: "index_locksmiths_on_certificate_number_and_is_verified", using: :btree
  add_index "locksmiths", ["company"], name: "index_locksmiths_on_company", using: :btree
  add_index "locksmiths", ["district_code"], name: "index_locksmiths_on_district_code", using: :btree
  add_index "locksmiths", ["mobile"], name: "index_locksmiths_on_mobile", using: :btree
  add_index "locksmiths", ["name"], name: "index_locksmiths_on_name", using: :btree
  add_index "locksmiths", ["phone"], name: "index_locksmiths_on_phone", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,                      null: false
    t.integer  "device_id",        limit: 4,                      null: false
    t.string   "device_type",      limit: 255,   default: "lock", null: false
    t.string   "oper_cmd",         limit: 255,                    null: false
    t.boolean  "is_deleted",                     default: false,  null: false
    t.datetime "created_at"
    t.string   "avatar_path",      limit: 255
    t.string   "gif_path",         limit: 255
    t.text     "ori_picture_urls", limit: 65535
    t.integer  "device_num",       limit: 4
    t.integer  "lock_type",        limit: 4
    t.string   "username",         limit: 255
  end

  add_index "messages", ["device_id", "lock_type", "device_num"], name: "index_messages_on_device_id_and_lock_type_and_device_num", using: :btree
  add_index "messages", ["user_id", "device_type", "device_id", "is_deleted"], name: "index_messages_on_user_devices", using: :btree
  add_index "messages", ["user_id", "device_type", "is_deleted"], name: "index_messages_on_user_all_devices", using: :btree
  add_index "messages", ["user_id", "is_deleted"], name: "index_messages_on_user", using: :btree
  add_index "messages", ["username"], name: "index_messages_on_username", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "intro",          limit: 255
    t.string   "image",          limit: 255
    t.decimal  "low_price",                    precision: 8, scale: 2, default: 0.0
    t.decimal  "origin_price",                 precision: 8, scale: 2, default: 0.0
    t.string   "subtitle",       limit: 255
    t.boolean  "on_sale",                                              default: true
    t.string   "units",          limit: 255
    t.text     "note",           limit: 65535
    t.integer  "stock_count",    limit: 4,                             default: 1000
    t.string   "summary_image",  limit: 255
    t.boolean  "is_discount",                                          default: false
    t.datetime "discounted_at"
    t.integer  "discount_score", limit: 4,                             default: 0
    t.integer  "orders_count",   limit: 4,                             default: 0
    t.integer  "likes_count",    limit: 4,                             default: 0
    t.integer  "postion",        limit: 4,                             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["is_discount"], name: "index_products_on_is_discount", using: :btree
  add_index "products", ["on_sale", "is_discount"], name: "index_products_on_on_sale_and_is_discount", using: :btree
  add_index "products", ["on_sale"], name: "index_products_on_on_sale", using: :btree
  add_index "products", ["postion"], name: "index_products_on_postion", using: :btree
  add_index "products", ["title"], name: "index_products_on_title", using: :btree

  create_table "send_sms_logs", force: :cascade do |t|
    t.string   "mobile",            limit: 255
    t.integer  "send_type",         limit: 4
    t.integer  "sms_total",         limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "first_sms_sent_at"
  end

  add_index "send_sms_logs", ["mobile", "send_type"], name: "index_mobile_type_on_sms_logs", using: :btree

  create_table "user_devices", force: :cascade do |t|
    t.integer "user_id",   limit: 4,             null: false
    t.integer "device_id", limit: 4,             null: false
    t.integer "ownership", limit: 4, default: 1, null: false
  end

  add_index "user_devices", ["device_id"], name: "index_user_devices_on_device_id", using: :btree
  add_index "user_devices", ["user_id", "device_id", "ownership"], name: "index_user_devices_on_owner", unique: true, using: :btree
  add_index "user_devices", ["user_id"], name: "index_user_devices_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "username",               limit: 255
    t.integer  "user_type",              limit: 4,   default: 1,  null: false, comment: "1用户、2锁匠、3商家、4管理员"
    t.string   "avatar",                 limit: 255
    t.string   "private_token",          limit: 255
    t.integer  "score",                  limit: 4,   default: 0,               comment: "积分"
    t.string   "district_code",          limit: 255
    t.string   "address",                limit: 255
    t.float    "latitude",               limit: 24
    t.float    "longitude",              limit: 24
  end

  add_index "users", ["address"], name: "index_users_on_address", using: :btree
  add_index "users", ["district_code"], name: "index_users_on_district_code", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_type"], name: "index_users_on_user_type", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
