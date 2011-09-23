require "spec_helper"

describe User do
  it { should have_many(:check_ins) }
  it { should have_many(:flights) }

  it "should expose #usernames" do
    users = create_list(:user, 3)
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
    let(:authentication_hash) do
      {
        "provider" => "twitter",
        "uid" => "12345",
        "credentials" => {
          "token" => "token",
          "secret" => "secret"
        },
        "user_info" => {
          "name" => "Test Name",
          "nickname" => "handle",
          "location" => "San Diego",
          "description" => "Test",
          "urls" => { "Website" => "http://bluepassers.com" },
          "image" => "http://bluepassers.com/images/logo.png"
        }
      }
    end

    context "with an exising user" do
      let!(:user) { create(:user) }

      it "should find that user" do
        described_class.initialize_with_omniauth(authentication_hash).should == user
      end
    end

    context "without an existing user" do
      it "should initialize a new user with provider and uid" do
        described_class.initialize_with_omniauth(authentication_hash).tap do |user|
          user.should be_new_record
          user.provider.should == "twitter"
          user.provider_uid.should == "12345"
        end
      end
    end

    it "should set attributes from authentication" do
      described_class.initialize_with_omniauth(authentication_hash).tap do |user|
        user.name.should == "Test Name"
        user.username.should == "handle"
        user.location.should == "San Diego"
        user.description.should == "Test"
        user.website.should == "http://bluepassers.com"
        user.avatar_url.should == "http://bluepassers.com/images/logo.png"
      end
    end
  end

  it "should follow_by_flight_master" do
    create(:user) do |user|
      FlightMaster.should_receive(:follow).with(user)
      user.follow_by_flight_master
    end
  end

end
