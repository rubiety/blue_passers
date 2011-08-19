class AddTweetedPassengersToFlights < ActiveRecord::Migration
  def self.up
    add_column :flights, :tweeted_passengers_at, :datetime
  end

  def self.down
    remove_column :flights, :tweeted_passengers_at
  end
end
