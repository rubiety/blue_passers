class Flight < ActiveRecord::Base
  belongs_to :origin, :class_name => "Airport"
  belongs_to :destination, :class_name => "Airport"

  def to_s
    "JBU#{number} #{origin} -> #{destination}"
  end
end
