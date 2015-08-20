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

ActiveRecord::Schema.define(version: 20150417181923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buckets", force: true do |t|
    t.string   "name",       null: false
    t.text     "description"
    t.datetime "created_at",    null: false
    t.integer  "created_by",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "updated_by",    null: false
    t.boolean  "active",        default: true
    t.string   "tags",          default: [],              array: true
    t.integer  "child_buckets", default: [],              array: true
    t.string   "template"
    t.string   "image"
  end

  create_table "links", force: true do |t|
    t.string   "name",                     null: false
    t.string   "url",                      null: false
    t.string   "domain",                   null: false
    t.string   "tags",        default: [],              array: true
    t.string   "kind"
    t.string   "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
    t.boolean  "is_article", default: false
    t.integer  "bucket_id",  null: false
  end

  create_table "notes", force: true do |t|
    t.string   "name",       null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.integer  "created_by", null: false
    t.datetime "updated_at", null: false
    t.integer  "updated_by", null: false
    t.integer  "bucket_id",  null: false
    t.boolean  "active",     default: true
    t.string   "tags",        default: [],              array: true
  end

  create_table "comments", force: true do |t|
    t.datetime "created_at", null: false
    t.integer  "created_by", null: false
    t.datetime "updated_at", null: false
    t.integer  "updated_by", null: false
    t.text     "data",       null: false
    t.integer  "grp_id",     null: false
    t.string   "grp_type",   null: false
  end

  create_table "domains", force: true do |t|
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.integer  "created_by",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.boolean  "is_article"
  end

  create_table "logs", force: true do |t|
    t.string   "kind"
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at"
    t.integer  "grp_id"
    t.string   "grp_type"
  end

  add_index "logs", ["grp_id"], name: "index_logs_on_grp_id", using: :btree
  add_index "logs", ["grp_type"], name: "index_logs_on_grp_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 140
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "email"
    t.string   "avatar"
    t.boolean  "active"
    t.string   "pass"
    t.string   "connect_via"
    t.string   "description"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end