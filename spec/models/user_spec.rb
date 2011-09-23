require "spec_helper"

describe User do
  it { should have_many(:check_ins) }
  it { should have_many(:flights) }

  it "should expose #usernames" do
    users = (1..3).map { create(:user) }
    described_class.usernames.should =~ users.map(&:username)
  end

  it "should expose #to_s as name" do
    described_class.new(:name => "Test").to_s.should == "Test"
  end

  it "should expose #handle as @-prefixed username" do
    build(:user).tap do |user|
      user.handle.should == "@" + user.username
    end
  end

  it "should expose airports as combined origin and destination airports from checkins" do
    pending
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
