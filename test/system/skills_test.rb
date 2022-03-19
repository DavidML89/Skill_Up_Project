require "application_system_test_case"

class SkillsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit skills_url

    assert_selector "h2", text: "Your results"
  end
end
