class AddTimeZoneToAirports < ActiveRecord::Migration
  def self.up
    add_column :airports, :time_zone_offset, :decimal, :precision => 5, :scale => 2
    add_column :airports, :time_zone_name, :string
    add_column :airports, :dst, :string, :limit => 1
    add_column :airports, :altitude, :integer
    add_column :airports, :latitude, :decimal, :precision => 9, :scale => 6
    add_column :airports, :longitude, :decimal, :precision => 9, :scale => 6
  end

  def self.down
    remove_column :airports, :latitude
    remove_column :airports, :longitude
    remove_column :airports, :altitude
    remove_column :airports, :dst
    remove_column :airports, :time_zone_name
    remove_column :airports, :time_zone_offset
  end
end
