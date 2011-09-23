require "spec_helper"

describe JetBlue::Flight do
  
  describe "looking up flight by number" do
    use_vcr_cassette
    
    it "should return flight object when valid"
  end

  describe "looking upcoming flight by number" do
    it "should use today's flight if within 3 hours of departure"
    it "should use tomorrow's flight if after 3 hours of departure"
  end
end
