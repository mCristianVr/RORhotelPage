require "application_system_test_case"

class StylesTest < ApplicationSystemTestCase
  setup do
    @style = styles(:one)
  end

  test "visiting the index" do
    visit styles_url
    assert_selector "h1", text: "Styles"
  end

  test "creating a Style" do
    visit styles_url
    click_on "New Style"

    fill_in "Cap", with: @style.cap
    fill_in "Desc", with: @style.desc
    fill_in "Price", with: @style.price
    click_on "Create Style"

    assert_text "Style was successfully created"
    click_on "Back"
  end

  test "updating a Style" do
    visit styles_url
    click_on "Edit", match: :first

    fill_in "Cap", with: @style.cap
    fill_in "Desc", with: @style.desc
    fill_in "Price", with: @style.price
    click_on "Update Style"

    assert_text "Style was successfully updated"
    click_on "Back"
  end

  test "destroying a Style" do
    visit styles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Style was successfully destroyed"
  end
end
