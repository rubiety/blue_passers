require "spec_helper"

feature "Browsing" do
  background do
    10.times { FactoryGirl.create(:check_in) }
  end

  scenario "Going to the Home Page" do
    visit root_path
  end
end

