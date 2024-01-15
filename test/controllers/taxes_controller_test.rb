require 'test_helper'

class TaxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tax = taxes(:one)
  end

  test 'should get index' do
    get taxes_url,
        headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('pratibha', 'secret') }
    assert_equal 'index', @controller.action_name
    assert_response :success
  end

  test 'should create tax with specific conditions' do
    post_tax_and_assert(5000, 1000, 'unmarried', 500, 2000,
                        'Your tax for monthly income of 5000.0 and annual income 62000.0 with insurance deduction of 1000.0 is 0.0')
    post_tax_and_assert(100_000, 1500, 'married', 1000, 3000,
                        'Your tax for monthly income of 100000.0 and annual income 1203000.0 with insurance deduction of 1500.0 is 110150.0')
    post_tax_and_assert(100_000, 1500, 'unmarried', 1000, 3000,
                        'Your tax for monthly income of 100000.0 and annual income 1203000.0 with insurance deduction of 1500.0 is 140150.0')
    post_tax_and_assert(100_000, 0, 'unmarried', 0, 0,
                        'Your tax for monthly income of 100000.0 and annual income 1200000.0 with insurance deduction of 0.0 is 145000.0')
    post_tax_and_assert(1_000_000, 0, 'unmarried', 0, 0,
                        'Your tax for monthly income of 1000000.0 and annual income 12000000.0 with insurance deduction of 0.0 is 4195000.0')
  end

  test 'should redirect back to form when monthly income is not present' do
    post taxes_url, params: {
      tax: {
        monthly_income: '',
        insurance_amount: 1000,
        marital_status: 'unmarried',
        ssf_amt: '',
        bonus: ''
      }
    }, headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('pratibha', 'secret') }, as: :turbo_stream

    assert_redirected_to taxes_path
  end

  private

  def post_tax_and_assert(monthly_income, insurance_amount, marital_status, ssf_amt, bonus, # rubocop:disable Metrics/MethodLength,Metrics/ParameterLists
                          expected_flash_notice)
    post taxes_url, params: {
      tax: {
        monthly_income:,
        insurance_amount:,
        marital_status:,
        ssf_amt:,
        bonus:
      }
    }, headers: { Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('pratibha', 'secret') }, as: :turbo_stream

    assert_response :success
    assert_template :create
    assert_equal expected_flash_notice, flash[:notice]
  end
end
