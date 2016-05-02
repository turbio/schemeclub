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

ActiveRecord::Schema.define(version: 20160429052834) do

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
    t.integer  "to_id"
    t.integer  "amount"
    t.integer  "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
  end

  add_index "transactions", ["ancestry"], name: "index_transactions_on_ancestry"
  add_index "transactions", ["from_id"], name: "index_transactions_on_from_id"
  add_index "transactions", ["to_id"], name: "index_transactions_on_to_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "password",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ancestry"
  end

  add_index "users", ["ancestry"], name: "index_users_on_ancestry"

end
