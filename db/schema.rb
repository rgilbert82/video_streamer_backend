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

ActiveRecord::Schema.define(version: 20180527023153) do

  create_table "channels", id: :string, force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "sqlite_autoindex_channels_1", unique: true
  end

  create_table "chats", id: :string, force: :cascade do |t|
    t.string   "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "page_token"
    t.index ["id"], name: "sqlite_autoindex_chats_1", unique: true
  end

  create_table "comments", id: :string, force: :cascade do |t|
    t.string   "chat_id"
    t.string   "user_id"
    t.string   "published_at"
    t.text     "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["id"], name: "sqlite_autoindex_comments_1", unique: true
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string   "username"
    t.string   "image_url"
    t.string   "youtube_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["id"], name: "sqlite_autoindex_users_1", unique: true
  end

  create_table "videos", id: :string, force: :cascade do |t|
    t.string   "channel_id"
    t.string   "title"
    t.string   "thumbnail"
    t.text     "description"
    t.string   "published_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["id"], name: "sqlite_autoindex_videos_1", unique: true
  end

end
