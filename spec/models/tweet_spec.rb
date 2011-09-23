require "spec_helper"

describe Tweet do
  it { should belong_to(:user) }
  it { should have_many(:check_ins) }

  let(:user) { create(:user) }

  describe "scopes" do
    it "should scope with_check_ins"
    it "should scope private"
    it "should scope public"
  end

  describe "creating from tweet" do
    let(:source_tweet) do
      mock("Tweet", {
        :user => mock("Tweet User", :screen_name => user.username),
        :text => "My sample tweet",
        :id_str => "12345",
        :in_reply_to_screen_name => "bluepassersdev2",
        :created_at => 8.hours.ago.to_s
      })
    end
    
    it "should create a new tweet" do
      described_class.from_twitter(source_tweet).tap do |tweet|
        tweet.should_not be_private
        tweet.user.should == user
        tweet.username.should == user.username
        tweet.text.should == "My sample tweet"
        tweet.reference.should == "12345"
        tweet.reply_to_username.should == "bluepassersdev2"
        tweet.tweeted_at.should be_a(Time)
      end
    end

  end

  describe "creating from direct message" do
    let(:source_dm) do
      mock("DM", {
        :sender_screen_name => user.username,
        :text => "My sample DM",
        :id_str => "12345",
        :created_at => 8.hours.ago.to_s
      })
    end

    it "should create a new private tweet" do
      described_class.from_direct_message(source_dm).tap do |tweet|
        tweet.should be_private
        tweet.user.should == user
        tweet.username.should == user.username
        tweet.text.should == "My sample DM"
        tweet.reference.should == "12345"
        tweet.tweeted_at.should be_a(Time)
      end
    end
  end

  describe "processing check ins" do

  end

end
