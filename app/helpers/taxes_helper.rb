# frozen_string_literal: true

module TaxesHelper
  def income_after_tax(duration, monthly_income, _result)
    if duration == 'monthly'
      (monthly_income.to_f - format('%.2f', @result / 12).to_f)
    else
      annual_income = monthly_income * 12
      (annual_income.to_f - format('%.2f', @result).to_f)
    end
  end
end
