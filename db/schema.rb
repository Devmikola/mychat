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

ActiveRecord::Schema.define(version: 20151118082924) do

  create_table "chats", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chats", ["user_id"], name: "index_chats_on_user_id"

  create_table "chats_users", force: true do |t|
    t.integer "chat_id"
    t.integer "user_id"
    t.integer "num_unread_msgs"
  end

  add_index "chats_users", ["chat_id", "user_id"], name: "index_chats_users_on_chat_id_and_user_id", unique: true

  create_table "messages", force: true do |t|
    t.integer  "chat_id"
    t.integer  "user_id"
    t.string   "text",       limit: 1000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
