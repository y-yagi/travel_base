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

ActiveRecord::Schema.define(version: 20141201235632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photo_service_user_infos", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "service_type",          null: false
    t.string   "photo_service_user_id", null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "photo_service_user_infos", ["user_id"], name: "index_photo_service_user_infos_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "address",                null: false
    t.text     "memo"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "urls",                                array: true
    t.datetime "deleted_at"
    t.integer  "user_id",                null: false
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "places", ["deleted_at", "user_id", "status"], name: "index_places_on_deleted_at_and_user_id_and_status", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.text     "memo"
    t.datetime "start_time",     null: false
    t.datetime "end_time",       null: false
    t.integer  "travel_date_id", null: false
    t.integer  "place_id",       null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "schedules", ["travel_date_id"], name: "index_schedules_on_travel_date_id", using: :btree

  create_table "travel_dates", force: :cascade do |t|
    t.date     "date",       null: false
    t.integer  "travel_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "travel_dates", ["travel_id"], name: "index_travel_dates_on_travel_id", using: :btree

  create_table "travel_photos", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "travel_id"
    t.integer  "photo_service_user_info_id"
    t.string   "photo_service_album_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "travel_photos", ["photo_service_user_info_id"], name: "index_travel_photos_on_photo_service_user_info_id", using: :btree
  add_index "travel_photos", ["travel_id"], name: "index_travel_photos_on_travel_id", using: :btree

  create_table "travels", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "memo"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "deleted_at"
    t.integer  "owner_id",   null: false
    t.integer  "members",                 array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "travels", ["deleted_at", "owner_id"], name: "index_travels_on_deleted_at_and_owner_id", using: :btree
  add_index "travels", ["members"], name: "index_travels_on_members", using: :gin

  create_table "users", force: :cascade do |t|
    t.string   "uid",        null: false
    t.string   "provider",   null: false
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["deleted_at", "uid", "provider"], name: "index_users_on_deleted_at_and_uid_and_provider", using: :btree

  add_foreign_key "travel_photos", "photo_service_user_infos"
  add_foreign_key "travel_photos", "travels"
end
