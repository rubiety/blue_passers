require 'spec_helper'

describe Flight do
  it { should belong_to(:origin) }
  it { should belong_to(:destination) }

  it "should expose #to_s as flight number, origin, destination" do
    pending
  end
end
