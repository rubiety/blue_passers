require "spec_helper"

describe Tweet do
  FLIGHT_FORMAT_EXAMPLES = {
    "On flight 123 Now" => ["flight 123"],
    "On #123 Now" => ["#123"],
    "On B6123 Now" => ["B6123"],
    "On JetBlue 123 Now" => ["JetBlue 123"],
    "On flt 123 Now" => ["flt 123"],
    "Boarding #123 then flight 456 - yes!" => ["#123", "flight 456"]
  }

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

  describe "flight reference formats" do
    FLIGHT_FORMAT_EXAMPLES.each do |text, value|
      it "should parse '#{text}' as #{value.inspect}" do
        described_class.extract_flight_references(text).should == value
      end
    end
  end

  describe "processing check ins" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, :user => user, :text => "On flight 123") }
    let(:flight) { create(:flight, :number => 123) }

    context "for an existing flight" do
      before do
        Flight.should_receive(:upcoming_by_number).and_return(flight)
      end

      it "should create a new check in" do
        expect { tweet.process_check_ins }.to change { user.check_ins.count }.by(1)
      end

      it "should include 'Found existing flight' in the log"
    end

    context "for a new flight" do
      before do
        JetBlue::Flight.new.tap do |jetblue_flight|
          Flight.should_receive(:upcoming_by_number).and_return(nil)
          JetBlue::Flight.should_receive(:upcoming_by_number).and_return(jetblue_flight)
          Flight.should_receive(:ensure_exists_from_jetblue).with(jetblue_flight).and_return(flight)
        end
      end

      it "should create a new check in" do
        expect { tweet.process_check_ins }.to change { user.check_ins.count }.by(1)
      end

      it "should include 'Found flight on JetBlue' in the log"
      it "should include 'Created flight from JetBlue' in the log"
    end
  end

end
