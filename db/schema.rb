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

ActiveRecord::Schema.define(version: 20161203082312) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_active",        default: true
  end

  create_table "complaints", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "title"
    t.string   "status"
    t.integer  "reference_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "complaints", ["order_id"], name: "index_complaints_on_order_id"

  create_table "item_prices", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "service_type_id"
    t.integer  "service_provider_id"
    t.integer  "price"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "item_prices", ["item_id"], name: "index_item_prices_on_item_id"
  add_index "item_prices", ["service_type_id"], name: "index_item_prices_on_service_type_id"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "is_active",  default: true
    t.string   "avatar"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.integer  "messageable_id"
    t.string   "messageable_type"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "messages", ["messageable_type", "messageable_id"], name: "index_messages_on_messageable_type_and_messageable_id"

  create_table "notifications", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.boolean  "is_read"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "order_comments", force: :cascade do |t|
    t.integer  "order_id"
    t.text     "body"
    t.string   "comment_by_type"
    t.integer  "comment_by_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order_item_id"
  end

  add_index "order_comments", ["order_id"], name: "index_order_comments_on_order_id"

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "service_type_id"
    t.integer  "quantity"
    t.float    "amount"
    t.text     "remarks"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "is_active",       default: true
  end

  add_index "order_items", ["item_id"], name: "index_order_items_on_item_id"
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"
  add_index "order_items", ["service_type_id"], name: "index_order_items_on_service_type_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "service_provider_id"
    t.integer  "logistic_id"
    t.float    "total_cost"
    t.float    "change_in_cost"
    t.string   "change_in_cost_reason"
    t.string   "comment"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "service_provider_chooser"
    t.integer  "status_id",                default: 1
    t.integer  "reference_id"
    t.boolean  "is_active",                default: true
  end

  create_table "payments", force: :cascade do |t|
    t.float    "amount"
    t.integer  "order_id"
    t.string   "status"
    t.string   "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id"

  create_table "refunds", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.boolean  "status"
    t.string   "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "refunds", ["user_id"], name: "index_refunds_on_user_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.integer  "review_by_id"
    t.string   "body"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order_id"
  end

  add_index "reviews", ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"

  create_table "schedules", force: :cascade do |t|
    t.integer  "order_id"
    t.date     "date"
    t.time     "to_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "from_time"
  end

  add_index "schedules", ["order_id"], name: "index_schedules_on_order_id"

  create_table "service_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "is_active",  default: true
  end

  create_table "status_dates", force: :cascade do |t|
    t.integer  "status_id"
    t.string   "status_name"
    t.integer  "order_id"
    t.date     "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "status_dates", ["order_id"], name: "index_status_dates_on_order_id"

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.string   "type"
    t.string   "mode"
    t.string   "remarks"
    t.float    "balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id"

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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "status"
    t.integer  "reference_id"
    t.integer  "experience"
    t.string   "shop_name"
    t.time     "open_time"
    t.time     "close_time"
    t.boolean  "is_open_on_sunday"
    t.integer  "capacity"
    t.integer  "max_workload"
    t.boolean  "is_partner"
    t.boolean  "is_verified",            default: false
    t.string   "level"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

  create_table "wallets", force: :cascade do |t|
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id"

end
