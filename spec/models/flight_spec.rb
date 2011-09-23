require "spec_helper"

describe Flight do
  it { should belong_to(:origin) }
  it { should belong_to(:destination) }
  it { should have_many(:check_ins) }
  it { should have_many(:users).through(:check_ins) }

  subject { create(:flight) }

  describe "scopes" do
    it "should scope recent"
    it "should scope for_tweet_notification"
  end

  it "should expose #to_s as flight number, origin, destination" do
    subject.to_s.should == "#{subject.number} #{subject.origin}->#{subject.destination}"
  end

  it "should expose local_start_at through origin time zone" do
    subject.start_at.should_receive(:in_time_zone).with(subject.origin.time_zone)
    subject.local_start_at
  end

  it "should expose local_end_at through destination time zone" do
    subject.end_at.should_receive(:in_time_zone).with(subject.destination.time_zone)
    subject.local_end_at
  end

  it "should expose local_last_check_in_at in Pacific Time" do
    pending
  end

  describe "ensuring flight existance from JetBlue" do
    context "when flight already exists" do
      it "should update flight with details from JetBlue"
    end

    context "when flight doesn't exist" do
      it "should create a new flight with details from JetBlue"
    end
  end
end
