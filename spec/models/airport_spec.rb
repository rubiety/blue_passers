require 'spec_helper'

describe Airport do
  it { should have_many(:flights_as_origin) }
  it { should have_many(:flights_as_destination) }

  it "should expose #to_s as code" do
    described_class.new(:code => "SAN").to_s.should == "SAN"
  end
end
