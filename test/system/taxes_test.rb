require "application_system_test_case"

class TaxesTest < ApplicationSystemTestCase
  setup do
    @tax = taxes(:one)
  end

  test "visiting the index" do
    visit taxes_url
    assert_selector "h1", text: "Taxes"
  end

  test "should create tax" do
    visit taxes_url
    click_on "New tax"

    click_on "Create Tax"

    assert_text "Tax was successfully created"
    click_on "Back"
  end

  test "should update Tax" do
    visit tax_url(@tax)
    click_on "Edit this tax", match: :first

    click_on "Update Tax"

    assert_text "Tax was successfully updated"
    click_on "Back"
  end

  test "should destroy Tax" do
    visit tax_url(@tax)
    click_on "Destroy this tax", match: :first

    assert_text "Tax was successfully destroyed"
  end
end
