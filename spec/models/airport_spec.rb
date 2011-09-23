require "spec_helper"

describe Airport do
  it { should have_many(:flights_as_origin) }
  it { should have_many(:flights_as_destination) }

  it "should expose flights as flights either as origin or destination" do
    create(:airport).tap do |airport|
      as_origin = create(:flight, :origin => airport)
      as_destination = create(:flight, :destination => airport)

      airport.flights.should =~ [as_origin, as_destination]
    end
  end

  it "should expose #to_s as code" do
    described_class.new(:code => "SAN").to_s.should == "SAN"
  end

  it "should compute distance to another airport" do
    create(:airport).distance_to(create(:airport)).should be_a(Float)
  end

  it "should expose time zone based on name" do
    build(:airport, :time_zone_name => "Eastern Time (US & Canada)").tap do |airport|
      airport.time_zone.should == ActiveSupport::TimeZone["Eastern Time (US & Canada)"]
    end
  end
end
