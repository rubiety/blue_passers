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
      t.integer :check_ins_count
      t.timestamps
    end

    add_index :users, [:provider, :provider_uid]
    add_index :users, :username

    create_table :airports do |t|
      t.string :code, :limit => 3
      t.string :name
      t.string :city_name
    end

    add_index :airports, :code

    create_table :flights do |t|
      t.integer :number
      t.integer :origin_id
      t.integer :destination_id
      t.datetime :start_at
      t.datetime :end_at
      t.integer :distance
      t.integer :check_ins_count
    end

    add_index :flights, :number
    add_index :flights, :origin_id
    add_index :flights, :destination_id

    create_table :check_ins do |t|
      t.references :flight
      t.references :user
      t.string :tweet_reference
      t.timestamps
    end

    add_index :check_ins, :flight_id
    add_index :check_ins, :user_id
  end

  def self.down
    drop_table :check_ins
    drop_table :flights
    drop_table :airports
    drop_table :users
  end
end
