# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_28_182354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "attractions", force: :cascade do |t|
    t.string "name", null: false
    t.string "shortDescription"
    t.string "fullDescription"
    t.string "place"
    t.string "time", null: false
    t.bigint "day_id"
    t.index ["day_id"], name: "index_attractions_on_day_id"
  end

  create_table "days", force: :cascade do |t|
    t.string "date", null: false
    t.string "name", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.decimal "lat", precision: 15, scale: 10, null: false
    t.decimal "lng", precision: 15, scale: 10, null: false
    t.bigint "pair_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "distance_left", null: false
    t.bigint "sender_id", null: false
    t.index ["lat", "lng"], name: "index_locations_on_lat_and_lng"
    t.index ["pair_id"], name: "index_locations_on_pair_id"
    t.index ["sender_id"], name: "index_locations_on_sender_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.boolean "finished", default: false, null: false
    t.integer "pair_nr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pair_nr"], name: "index_pairs_on_pair_nr", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.boolean "verified_login", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "city"
    t.string "verification_code"
    t.bigint "pair_id", null: false
    t.string "messenger"
    t.boolean "is_phone_enabled", default: true
    t.string "facebook"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["pair_id"], name: "index_users_on_pair_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "locations", "users", column: "sender_id"
end
