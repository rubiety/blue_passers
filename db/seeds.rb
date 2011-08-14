# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

YAML.load_file(Rails.root.join("db/seeds/airports.yml")).tap do |data|
  data.each do |entry|
    Airport.find_or_initialize_by_code(entry["code"]).tap do |airport|
      airport.attributes = entry
      airport.save!
    end
  end
end

