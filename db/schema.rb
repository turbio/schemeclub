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

ActiveRecord::Schema.define(version: 20161030002557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount",                     null: false
    t.integer  "direction",                  null: false
    t.string   "address",                    null: false
    t.boolean  "confirmed",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "recruit_codes", force: :cascade do |t|
    t.integer  "owner_id",   null: false
    t.string   "code",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recruit_codes", ["owner_id"], name: "index_recruit_codes_on_owner_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "from_id"
    t.decimal  "amount",     null: false
    t.integer  "reason",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "transactions", ["from_id"], name: "index_transactions_on_from_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "password",        null: false
    t.string   "ancestry"
    t.integer  "recruit_code_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["recruit_code_id"], name: "index_users_on_recruit_code_id", using: :btree

  create_table "users_transactions", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "transaction_id"
  end

  add_index "users_transactions", ["transaction_id"], name: "index_users_transactions_on_transaction_id", using: :btree
  add_index "users_transactions", ["user_id"], name: "index_users_transactions_on_user_id", using: :btree

  add_foreign_key "payments", "users"
  add_foreign_key "recruit_codes", "users", column: "owner_id"
  add_foreign_key "transactions", "users", column: "from_id"
end
