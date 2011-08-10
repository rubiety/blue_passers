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
    t.integer  "tweet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "check_ins", ["flight_id"], :name => "index_check_ins_on_flight_id"
  add_index "check_ins", ["tweet_id"], :name => "index_check_ins_on_tweet_id"
  add_index "check_ins", ["user_id"], :name => "index_check_ins_on_user_id"

  create_table "flights", :force => true do |t|
    t.integer  "number"
    t.integer  "origin_id"
    t.integer  "destination_id"
    t.datetime "start_at"
    t.datetime "actual_start_at"
    t.datetime "end_at"
    t.datetime "actual_end_at"
    t.integer  "distance"
    t.integer  "check_ins_count",  :default => 0, :null => false
    t.datetime "last_check_in_at"
  end

  add_index "flights", ["destination_id"], :name => "index_flights_on_destination_id"
  add_index "flights", ["number"], :name => "index_flights_on_number"
  add_index "flights", ["origin_id"], :name => "index_flights_on_origin_id"

  create_table "tweets", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "text"
    t.string   "reference"
    t.string   "reply_to_username"
    t.datetime "tweeted_at"
    t.datetime "created_at"
    t.integer  "check_ins_count",   :default => 0, :null => false
  end

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
    t.integer  "check_ins_count",                             :default => 0,    :null => false
    t.integer  "distance_sum",                                :default => 0,    :null => false
    t.integer  "airports_count",                              :default => 0,    :null => false
    t.integer  "last_processed_tweet_reference", :limit => 8
    t.boolean  "tweet_before_departure",                      :default => true, :null => false
    t.boolean  "show_on_leaderboard",                         :default => true, :null => false
    t.boolean  "expose_flight_history",                       :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["provider", "provider_uid"], :name => "index_users_on_provider_and_provider_uid"
  add_index "users", ["username"], :name => "index_users_on_username"

end
