require "spec_helper"

feature "Browsing" do
  background do
    10.times { FactoryGirl.create(:check_in) }
  end

  scenario "Going to the Home Page" do
    visit root_path
  end

  scenario "Browsing Airports" do
    visit root_path
    within("nav") do
      click_link "Airports"
    end
  end

  scenario "Browsing Flights" do
    visit root_path
    within("nav") do
      click_link "Flights"
    end
  end
end

