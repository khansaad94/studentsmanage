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

ActiveRecord::Schema.define(version: 20151020115909) do

  create_table "braintree_infos", force: true do |t|
    t.string   "customer_id"
    t.string   "payment_method_token"
    t.string   "card_type"
    t.boolean  "status"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "braintree_infos", ["user_id"], name: "index_braintree_infos_on_user_id", using: :btree

  create_table "celebrities", force: true do |t|
    t.string   "about_me",                                             null: false
    t.text     "description",                                          null: false
    t.float    "default_rate",              limit: 24,                 null: false
    t.float    "per_alphabet_rate",         limit: 24,                 null: false
    t.boolean  "verified_account",                     default: false, null: false
    t.datetime "date_of_birth"
    t.text     "fb_link"
    t.text     "tw_link"
    t.text     "pin_link"
    t.text     "gmail_link"
    t.text     "sn_link"
    t.text     "in_link"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "industry_id"
    t.integer  "monthly_videos"
    t.integer  "default_delivery_days"
    t.integer  "additional_monthly_videos"
    t.float    "charity_rate",              limit: 24
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "video_url"
    t.boolean  "is_video_verified",                    default: false
  end

  create_table "celebrity_charities", force: true do |t|
    t.float    "charity_percentage", limit: 24, null: false
    t.integer  "celebrity_id"
    t.integer  "charity_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charity_accounts", force: true do |t|
    t.string   "name"
    t.string   "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codes", force: true do |t|
    t.string   "code_name"
    t.boolean  "is_consumed",  default: false
    t.datetime "consumed_on"
    t.string   "device_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_mailer_informations", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "order_number"
    t.string   "site_issue"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industries", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.string   "message_for",                       null: false
    t.string   "pronounce_like",                    null: false
    t.boolean  "is_gift"
    t.text     "message_details",                   null: false
    t.datetime "deadline"
    t.integer  "celebrity_id",                      null: false
    t.integer  "event_type_id",                     null: false
    t.string   "status"
    t.string   "video_url"
    t.datetime "delivery_date"
    t.string   "customer_job_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.boolean  "is_public",          default: true
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "payment_addresses", force: true do |t|
    t.string   "legal_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "celebrity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mail_to_name"
    t.string   "zip_code"
  end

  add_index "payment_addresses", ["celebrity_id"], name: "index_payment_addresses_on_celebrity_id", using: :btree

  create_table "profiles", force: true do |t|
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.string   "phone"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "transaction_histories", force: true do |t|
    t.string   "transaction_id"
    t.string   "status"
    t.string   "transaction_type"
    t.decimal  "transaction_amount",   precision: 10, scale: 0
    t.decimal  "braintree_fee_amount", precision: 10, scale: 0
    t.decimal  "celebvidy_fee_amount", precision: 10, scale: 0
    t.string   "merchant_id"
    t.string   "customer_id"
    t.integer  "user_id"
    t.decimal  "price",                precision: 10, scale: 0
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",                 null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_type",                                           null: false
    t.string   "facebook_id"
    t.string   "twitter_id"
    t.string   "device_token"
    t.boolean  "is_admin",               default: false,              null: false
    t.boolean  "is_active",              default: true,               null: false
    t.boolean  "is_deleted",             default: false,              null: false
    t.string   "customer_id"
    t.string   "merchant_id"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.string   "session_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "full_name"
    t.boolean  "push_notification",      default: false
    t.boolean  "away_mode",              default: false
    t.string   "account_type",           default: "Personal Account"
    t.string   "agent_code"
    t.boolean  "code_verify",            default: false
    t.boolean  "payment_by_check",       default: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
