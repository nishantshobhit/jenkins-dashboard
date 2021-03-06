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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121212135221) do

  create_table "builds", :force => true do |t|
    t.integer  "job_id"
    t.integer  "duration"
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "success"
    t.string   "url"
    t.datetime "date"
  end

  create_table "builds_developers", :id => false, :force => true do |t|
    t.integer "build_id"
    t.integer "developer_id"
  end

  create_table "commits", :force => true do |t|
    t.text     "message"
    t.string   "sha1hash"
    t.integer  "insertions"
    t.integer  "deletions"
    t.integer  "files_changed"
    t.integer  "developer_id"
    t.integer  "build_id"
    t.datetime "date"
    t.integer  "spelling_mistakes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "dashboards", :force => true do |t|
    t.string   "name"
    t.string   "layout"
    t.boolean  "locked",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "developers", :force => true do |t|
    t.string   "name"
    t.integer  "broken_build_count"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  create_table "test_reports", :force => true do |t|
    t.integer  "duration"
    t.integer  "failed"
    t.integer  "passed"
    t.integer  "skipped"
    t.integer  "build_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "widgets", :force => true do |t|
    t.string   "name"
    t.integer  "job_id"
    t.integer  "dashboard_id"
    t.integer  "data_type"
    t.integer  "layout"
    t.integer  "size"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
