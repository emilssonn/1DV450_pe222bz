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

ActiveRecord::Schema.define(version: 20140216162311) do

  create_table "api_keys", force: true do |t|
    t.integer  "application_id",            null: false
    t.string   "key",            limit: 40, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_rate_limits", force: true do |t|
    t.string   "name",       limit: 30, null: false
    t.integer  "limit",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.integer  "user_id",                                             null: false
    t.integer  "application_rate_limit_id",            default: 1,    null: false
    t.string   "name",                      limit: 30,                null: false
    t.boolean  "active",                               default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", force: true do |t|
    t.string   "public_id",   limit: 50,   null: false
    t.string   "name",        limit: 100,  null: false
    t.text     "description", limit: 2000
    t.string   "url",         limit: 200
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_types", force: true do |t|
    t.string   "public_id",   limit: 50,  null: false
    t.string   "name",        limit: 50,  null: false
    t.text     "description", limit: 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.string   "public_id",        limit: 50,   null: false
    t.integer  "resource_type_id",              null: false
    t.integer  "user_id",                       null: false
    t.integer  "license_id",                    null: false
    t.string   "name",             limit: 100,  null: false
    t.text     "description",      limit: 2000, null: false
    t.string   "url",              limit: 200,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources_tags", id: false, force: true do |t|
    t.integer "tag_id",      null: false
    t.integer "resource_id", null: false
  end

  add_index "resources_tags", ["tag_id", "resource_id"], name: "index_resources_tags_on_tag_id_and_resource_id", unique: true

  create_table "tags", force: true do |t|
    t.string   "public_id",  limit: 50, null: false
    t.string   "name",       limit: 20, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "user_roles", force: true do |t|
    t.string "name", limit: 30, null: false
  end

  create_table "users", force: true do |t|
    t.string   "public_id",       limit: 50,             null: false
    t.string   "firstname",       limit: 40,             null: false
    t.string   "lastname",        limit: 40,             null: false
    t.string   "email",           limit: 40,             null: false
    t.string   "password_digest",                        null: false
    t.integer  "user_role_id",               default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
