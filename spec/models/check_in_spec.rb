require "spec_helper"

describe CheckIn do
  it { should belong_to(:user) }
  it { should belong_to(:flight) }
  it { should belong_to(:tweet) }

  let(:user) { create(:user) }
  let(:flight) { create(:flight) }

  context "scopes" do
    it "should expose recent"
    it "should expose exposed"
  end

  it "should expose #to_s as user on flight" do
    create(:check_in).tap do |check_in|
      check_in.to_s.should == "#{check_in.user} on #{check_in.flight}"
    end
  end

  it "should update user stats on create" do
    build(:check_in, :user => user).tap do |check_in|
      user.should_receive(:update_distance_sum)
      user.should_receive(:update_airports_count)
      check_in.save!
    end
  end

  it "should update user stats on destroy" do
    create(:check_in, :user => user).tap do |check_in|
      user.should_receive(:update_distance_sum)
      user.should_receive(:update_airports_count)
      check_in.destroy
    end
  end

  it "should update airport stats on create" do
    pending

    build(:check_in, :flight => flight).tap do |check_in|
      [:origin, :destination].each do |method|
        flight.send(method).should_receive(:update_check_ins_count)
        flight.send(method).should_receive(:update_unique_visitors_count)
      end

      check_in.save!
    end
  end
  
  it "should update airport stats on destroy" do
    pending

    create(:check_in, :flight => flight).tap do |check_in|
      [:origin, :destination].each do |method|
        flight.send(method).should_receive(:update_check_ins_count)
        flight.send(method).should_receive(:update_unique_visitors_count)
      end

      check_in.destroy
    end
  end
  
end
