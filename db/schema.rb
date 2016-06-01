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

ActiveRecord::Schema.define(version: 20160601162643) do

  create_table "item_prices", force: :cascade do |t|
    t.integer  "service_provider_id"
    t.integer  "item_id"
    t.integer  "service_type_id"
    t.float    "price"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "item_prices", ["item_id"], name: "index_item_prices_on_item_id"
  add_index "item_prices", ["service_provider_id"], name: "index_item_prices_on_service_provider_id"
  add_index "item_prices", ["service_type_id"], name: "index_item_prices_on_service_type_id"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
