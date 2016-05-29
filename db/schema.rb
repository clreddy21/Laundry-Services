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

ActiveRecord::Schema.define(version: 20160529171958) do

  create_table "item_prices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.float    "iron"
    t.float    "wash"
    t.float    "wash_iron"
    t.float    "dry_cleaning"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "item_prices", ["item_id"], name: "index_item_prices_on_item_id"
  add_index "item_prices", ["user_id"], name: "index_item_prices_on_user_id"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_comments", force: :cascade do |t|
    t.integer  "order_id"
    t.text     "body"
    t.string   "comment_by_type"
    t.integer  "comment_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "order_comments", ["order_id"], name: "index_order_comments_on_order_id"

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.float    "amount"
    t.text     "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "order_items", ["item_id"], name: "index_order_items_on_item_id"
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "service_provider_id"
    t.float    "total_cost"
    t.float    "change_in_cost"
    t.string   "change_in_cost_reason"
    t.string   "status"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id"
  add_index "orders", ["service_provider_id"], name: "index_orders_on_service_provider_id"

  create_table "service_types", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "wash"
    t.boolean  "iron"
    t.boolean  "wash_iron"
    t.boolean  "dry_cleaning"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "service_types", ["user_id"], name: "index_service_types_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile"
    t.text     "jwt"
    t.boolean  "is_active"
    t.string   "avatar"
    t.integer  "reviews_count",          default: 0
    t.float    "average_review",         default: 0.0
    t.string   "type"
    t.string   "slug"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "gcm_id"
    t.string   "otp"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

end
