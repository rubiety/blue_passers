class AddPrivateToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :private, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :tweets, :private
  end
end
