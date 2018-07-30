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

ActiveRecord::Schema.define(version: 2018_07_30_225239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "deleted_data", id: :serial, force: :cascade do |t|
    t.string "table_name"
    t.integer "datum_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_deleted_data_on_updated_at"
  end

  create_table "dropbox_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.integer "travel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["travel_id"], name: "index_dropbox_files_on_travel_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "detail"
    t.integer "user_id"
    t.integer "place_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["place_id"], name: "index_events_on_place_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "confidential", default: true, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "photo_service_user_infos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "service_type", null: false
    t.string "photo_service_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_photo_service_user_infos_on_user_id"
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.text "memo"
    t.float "latitude"
    t.float "longitude"
    t.string "urls", array: true
    t.integer "user_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tags", array: true
    t.index ["tags"], name: "index_places_on_tags", using: :gin
  end

  create_table "places_stations", id: false, force: :cascade do |t|
    t.integer "place_id", null: false
    t.integer "station_id", null: false
    t.string "distance"
    t.index ["place_id", "station_id"], name: "index_places_stations_on_place_id_and_station_id"
    t.index ["station_id", "place_id"], name: "index_places_stations_on_station_id_and_place_id"
  end

  create_table "routes", id: :serial, force: :cascade do |t|
    t.text "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", id: :serial, force: :cascade do |t|
    t.text "memo"
    t.time "start_time"
    t.time "end_time"
    t.integer "travel_date_id", null: false
    t.integer "place_id", null: false
    t.integer "route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "purpose"
    t.index ["travel_date_id"], name: "index_schedules_on_travel_date_id"
  end

  create_table "stations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "line"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "todos", id: :serial, force: :cascade do |t|
    t.integer "travel_id"
    t.integer "user_id"
    t.text "detail"
    t.datetime "deadline_at"
    t.boolean "finished", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["travel_id"], name: "index_todos_on_travel_id"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "travel_dates", id: :serial, force: :cascade do |t|
    t.date "date", null: false
    t.integer "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["travel_id"], name: "index_travel_dates_on_travel_id"
  end

  create_table "travel_photos", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "travel_id"
    t.integer "photo_service_user_info_id"
    t.string "photo_service_album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photo_service_user_info_id"], name: "index_travel_photos_on_photo_service_user_info_id"
    t.index ["travel_id"], name: "index_travel_photos_on_travel_id"
  end

  create_table "travels", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "memo"
    t.date "start_date"
    t.date "end_date"
    t.integer "owner_id", null: false
    t.integer "members", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["members"], name: "index_travels_on_members", using: :gin
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "uid", null: false
    t.string "provider", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "auto_archive", default: false
    t.boolean "notification", default: false
    t.string "device_token"
    t.boolean "admin", default: false
  end

  add_foreign_key "dropbox_files", "travels"
  add_foreign_key "events", "places"
  add_foreign_key "events", "users"
  add_foreign_key "todos", "travels"
  add_foreign_key "todos", "users"
  add_foreign_key "travel_photos", "photo_service_user_infos"
  add_foreign_key "travel_photos", "travels"
end
