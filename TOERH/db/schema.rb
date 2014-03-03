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

ActiveRecord::Schema.define(version: 20140303185027) do

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

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                                     null: false
    t.string   "uid",                                      null: false
    t.string   "secret",                                   null: false
    t.text     "redirect_uri",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "application_rate_limit_id", default: 1,    null: false
    t.boolean  "active",                    default: true, null: false
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

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
