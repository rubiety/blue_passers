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

ActiveRecord::Schema.define(:version => 20110807222756) do

  create_table "airports", :force => true do |t|
    t.string "code",      :limit => 3
    t.string "name"
    t.string "city_name"
  end

  add_index "airports", ["code"], :name => "index_airports_on_code"

  create_table "check_ins", :force => true do |t|
    t.integer  "flight_id"
    t.integer  "user_id"
    t.string   "tweet_reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "check_ins", ["flight_id"], :name => "index_check_ins_on_flight_id"
  add_index "check_ins", ["user_id"], :name => "index_check_ins_on_user_id"

  create_table "flights", :force => true do |t|
    t.integer  "number"
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "distance"
    t.integer  "check_ins_count"
  end

  add_index "flights", ["destination_id"], :name => "index_flights_on_destination_id"
  add_index "flights", ["number"], :name => "index_flights_on_number"
  add_index "flights", ["origin_id"], :name => "index_flights_on_origin_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "provider_uid"
    t.string   "provider_token"
    t.string   "provider_secret"
    t.string   "username"
    t.string   "name"
    t.string   "location"
    t.string   "website"
    t.string   "description"
    t.string   "avatar_url"
    t.integer  "check_ins_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["provider", "provider_uid"], :name => "index_users_on_provider_and_provider_uid"
  add_index "users", ["username"], :name => "index_users_on_username"

end
