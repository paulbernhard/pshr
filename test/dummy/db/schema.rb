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

ActiveRecord::Schema.define(version: 2019_04_08_083047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_uploads", force: :cascade do |t|
    t.text "file_data"
    t.jsonb "metadata", default: {}
    t.integer "order"
    t.boolean "processing"
    t.string "uploadable_type"
    t.bigint "uploadable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_custom_uploads_on_uploadable_type_and_uploadable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.text "file_data"
    t.jsonb "metadata", default: {}
    t.integer "order"
    t.boolean "processing"
    t.string "uploadable_type"
    t.bigint "uploadable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_uploads_on_uploadable_type_and_uploadable_id"
  end

end
