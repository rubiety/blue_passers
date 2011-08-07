class CheckIn < ActiveRecord::Base
  belongs_to :user
  belongs_to :flight
  
  def to_s
    "#{user} on #{flight}"
  end
end
