class CheckIn < ActiveRecord::Base
  belongs_to :user
  belongs_to :flight
  belongs_to :tweet
  
  def to_s
    "#{user} on #{flight}"
  end
end
