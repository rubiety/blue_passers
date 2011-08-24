class ResetUserAirportsCount < ActiveRecord::Migration
  def self.up
    say_with_time("Resetting airports count for all users...") do
      User.all.each do |user|
        user.update_airports_count
      end
    end
  end

  def self.down
  end
end
