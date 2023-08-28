# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_08_25_054550) do

  create_table "inventory_lists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "inventory_list_name", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_inventory_lists_on_user_id"
  end

  create_table "item_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_category_name", null: false
    t.bigint "preset_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_category_name", "preset_id"], name: "index_item_categories_on_item_category_name_and_preset_id", unique: true
    t.index ["preset_id"], name: "index_item_categories_on_preset_id"
  end

  create_table "live_times", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "live_date"
    t.time "opening_time"
    t.time "start_time"
    t.bigint "schedule_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedule_id"], name: "index_live_times_on_schedule_id"
  end

  create_table "preset_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "preset_item_name", null: false
    t.bigint "item_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "amazon_url_or_product_name"
    t.index ["item_category_id"], name: "index_preset_items_on_item_category_id"
  end

  create_table "presets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "preset_name", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_presets_on_user_id"
  end

  create_table "properties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "property_name", null: false
    t.bigint "property_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "amazon_url_or_product_name"
    t.index ["property_category_id"], name: "index_properties_on_property_category_id"
  end

  create_table "property_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "category_name", null: false
    t.bigint "inventory_list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_name", "inventory_list_id"], name: "index_property_categories_unique", unique: true
    t.index ["inventory_list_id"], name: "index_property_categories_on_inventory_list_id"
  end

  create_table "purchase_lists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "purchase_list_name", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_purchase_lists_on_user_id"
  end

  create_table "purchases", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "purchase_name", null: false
    t.integer "price", null: false
    t.integer "quantity", null: false
    t.bigint "purchase_list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["purchase_list_id"], name: "index_purchases_on_purchase_list_id"
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "schedule_name", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "venue"
    t.string "lodging"
    t.text "memo"
    t.bigint "user_id"
    t.bigint "inventory_list_id"
    t.bigint "purchase_list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventory_list_id"], name: "index_schedules_on_inventory_list_id"
    t.index ["purchase_list_id"], name: "index_schedules_on_purchase_list_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "inventory_lists", "users"
  add_foreign_key "item_categories", "presets"
  add_foreign_key "live_times", "schedules"
  add_foreign_key "preset_items", "item_categories"
  add_foreign_key "presets", "users"
  add_foreign_key "properties", "property_categories"
  add_foreign_key "property_categories", "inventory_lists"
  add_foreign_key "purchase_lists", "users"
  add_foreign_key "purchases", "purchase_lists"
  add_foreign_key "schedules", "inventory_lists"
  add_foreign_key "schedules", "purchase_lists"
  add_foreign_key "schedules", "users"
end
