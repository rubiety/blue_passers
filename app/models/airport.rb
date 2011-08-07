class Airport < ActiveRecord::Base
  has_many :flights_as_origin, :class_name => "Flight", :foreign_key => "origin_id"
  has_many :flights_as_destination, :class_name => "Flight", :foreign_key => "destination_id"
  has_many :check_ins_as_origin, :class_name => "CheckIn", :through => :flights_as_origin
  has_many :check_ins_as_destination, :class_name => "CheckIn", :through => :flights_as_destination

  def to_s
    code
  end
end
