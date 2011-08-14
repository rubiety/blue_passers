class Airport < ActiveRecord::Base
  has_many :flights_as_origin, :class_name => "Flight", :foreign_key => "origin_id"
  has_many :flights_as_destination, :class_name => "Flight", :foreign_key => "destination_id"
  has_many :flights, :class_name => "Flight", :finder_sql => 'SELECT DISTINCT * FROM flights WHERE origin_id = #{id} or destination_id = #{id}'
  has_many :check_ins_as_origin, :class_name => "CheckIn", :through => :flights_as_origin, :source => :origin
  has_many :check_ins_as_destination, :class_name => "CheckIn", :through => :flights_as_destination, :source => :destination
  has_many :check_ins, :class_name => "CheckIn", :finder_sql => 'SELECT ci.* FROM check_ins ci INNER JOIN flights f ON ci.id = f.destination_id WHERE f.destination_id = #{id} OR f.origin_id = #{id}'

  has_friendly_id :code_with_city_name, :use_slug => true

  def to_s
    code
  end

  def code_with_city_name
    "#{code} - #{city_name}"
  end

  def check_ins_count
    check_ins_as_origin_count + check_ins_as_destination_count
  end

  def update_check_ins_count
    update_attribute(:check_ins_as_origin_count, check_ins_as_origin.count)
    update_attribute(:check_ins_as_destination_count, check_ins_as_destination.count)
  end

  def update_unique_visitors_count
    update_attributes(:unique_visitors_count, check_ins.count("DISTINCT user_id"))
  end
end
