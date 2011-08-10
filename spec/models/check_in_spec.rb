require 'spec_helper'

describe CheckIn do
  it { should belong_to(:user) }
  it { should belong_to(:flight) }
  it { should belong_to(:tweet) }

  it "should expose #to_s as user on flight" do
    pending
  end
end
