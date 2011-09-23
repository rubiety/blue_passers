require "spec_helper"
require "cancan/matchers"

describe Ability do
  let(:user) { create(:user) }
  subject { Ability.new(user) }

  specify "user should be able to manage himself" do
    should be_able_to(:manage, user)
  end

  specify "user should not be able ot manage another user" do
    should_not be_able_to(:manage, Factory(:user))
  end
end
