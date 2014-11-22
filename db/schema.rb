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

ActiveRecord::Schema.define(version: 20141121044236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "memo"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "website"
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "places", ["deleted_at"], name: "index_places_on_deleted_at", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "schedules", force: true do |t|
    t.text     "memo"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "travel_date_id"
    t.integer  "place_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "travel_dates", force: true do |t|
    t.date     "date"
    t.integer  "travel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "travel_dates", ["travel_id"], name: "index_travel_dates_on_travel_id", using: :btree

  create_table "travels", force: true do |t|
    t.string   "name"
    t.text     "memo"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "travels", ["deleted_at", "user_id"], name: "index_travels_on_deleted_at_and_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
    t.string   "email"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
