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

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.integer  "direction"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id"

  create_table "recruit_codes", force: :cascade do |t|
    t.integer  "owner_id",   null: false
    t.string   "code",       null: false
    t.boolean  "claimed",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recruit_codes", ["owner_id"], name: "index_recruit_codes_on_owner_id"

  create_table "transactions", force: :cascade do |t|
    t.integer  "from_id"
    t.decimal  "amount",     null: false
    t.integer  "reason",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "transactions", ["from_id"], name: "index_transactions_on_from_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "password",   null: false
    t.string   "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_transactions", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "transaction_id"
  end

  add_index "users_transactions", ["transaction_id"], name: "index_users_transactions_on_transaction_id"
  add_index "users_transactions", ["user_id"], name: "index_users_transactions_on_user_id"

end
