require 'spec_helper'

describe Tweet do
  it { should belong_to(:user) }
  it { should have_many(:check_ins) }


end
