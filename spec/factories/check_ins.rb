Factory.define :check_in do |f|
  f.association :flight
  f.association :user
  f.association :tweet  # TODO: Make dependent on number generated from flight?
end