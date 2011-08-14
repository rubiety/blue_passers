class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :provider_uid
      t.string :provider_token
      t.string :provider_secret
      t.string :username
      t.string :name
      t.string :location
      t.string :website
      t.string :description
      t.string :avatar_url
      t.integer :check_ins_count, :default => 0, :null => false
      t.integer :distance_sum, :default => 0, :null => false
      t.integer :airports_count, :default => 0, :null => false
      t.boolean :tweet_before_departure, :default => true, :null => false
      t.boolean :show_on_leaderboard, :default => true, :null => false
      t.boolean :expose_flight_history, :default => true, :null => false
      t.timestamps
    end

    add_index :users, [:provider, :provider_uid]
    add_index :users, :username

    create_table :airports do |t|
      t.string :code, :limit => 3
      t.string :name
      t.string :city_name
      t.integer :flights_as_origin_count, :default => 0, :null => false
      t.integer :flights_as_destination_count, :default => 0, :null => false
      t.integer :check_ins_as_origin_count, :default => 0, :null => false
      t.integer :check_ins_as_destination_count, :default => 0, :null => false
      t.integer :unique_visitors_count, :default => 0, :null => false
    end

    add_index :airports, :code

    create_table :flights do |t|
      t.integer :number
      t.integer :origin_id
      t.integer :destination_id
      t.datetime :start_at
      t.datetime :actual_start_at
      t.datetime :end_at
      t.datetime :actual_end_at
      t.integer :distance
      t.integer :check_ins_count, :default => 0, :null => false
      t.datetime :last_check_in_at
    end

    add_index :flights, :number
    add_index :flights, :origin_id
    add_index :flights, :destination_id

    create_table :check_ins do |t|
      t.references :flight
      t.references :user
      t.references :tweet
      t.timestamps
    end

    add_index :check_ins, :flight_id
    add_index :check_ins, :user_id
    add_index :check_ins, :tweet_id

    create_table :tweets do |t|
      t.references :user
      t.string :username
      t.string :text
      t.string :reference
      t.string :reply_to_username
      t.datetime :tweeted_at
      t.datetime :created_at
      t.integer :check_ins_count, :default => 0, :null => false
    end


    create_table :slugs do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end
    
    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  end

  def self.down
    drop_table :slugs
    drop_table :tweets
    drop_table :check_ins
    drop_table :flights
    drop_table :airports
    drop_table :users
  end
end
