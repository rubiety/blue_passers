require 'spec_helper'

describe User do
  it { should have_many(:check_ins) }
  it { should have_many(:flights) }

  it "should expose #to_s as name" do
    described_class.new(:name => "Test").to_s.should == "Test"
  end

  describe "authenticating with omniauth" do
    context "with an exising user" do
      it "should find that user" do
        pending
      end
    end

    context "without an existing user" do
      it "should initialize a new user with provider and uid" do
        pending
      end
    end

    it "should refresh attributes from authentication" do
      pending
    end
  end
end
