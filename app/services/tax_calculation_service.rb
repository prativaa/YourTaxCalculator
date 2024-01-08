# frozen_string_literal: true

class TaxCalculationService
  def initialize(taxable_income, base_taxable_income, income_diff, ssf_amt, marital_status)
    @taxable_income = taxable_income
    @base_taxable_income = base_taxable_income
    @income_diff = income_diff
    @ssf_amt = ssf_amt
    @marital_status = marital_status
  end

  def execute
    calculate_tax
  end

  private

  def calculate_tax
    taxes = {}
    puts "Taxable income: #{@taxable_income}"
    puts "Base taxable income: #{@base_taxable_income}"

    if @taxable_income <= @base_taxable_income

      tax, taxes = calculate_base_tax(taxes, 1.0, @taxable_income)
      [tax, taxes]
    elsif @income_diff.positive?
      tax, taxes = calculate_base_tax(taxes, 1.0, @base_taxable_income)

      remaining_taxable_money = @income_diff

      remaining_taxable_money, tax = calculate_tax_band(10.0, tax, 200_000, remaining_taxable_money, taxes)
      return tax, taxes if remaining_taxable_money.zero?

      remaining_taxable_money, tax = calculate_tax_band(20.0, tax, 300_000, remaining_taxable_money, taxes)
      return tax, taxes if remaining_taxable_money.zero?

      remaining_taxable_money, tax = calculate_tax_band(30.0, tax, @marital_status == 'unmarried' ? 1_000_000 : 900_000,
                                                        remaining_taxable_money, taxes)
      return tax, taxes if remaining_taxable_money.zero?

      remaining_taxable_money, tax = calculate_tax_band(36.0, tax, 3_000_000, remaining_taxable_money, taxes)
      return tax, taxes if remaining_taxable_money.zero?

      remaining_taxable_money, tax = calculate_tax_band(39.0, tax, remaining_taxable_money, remaining_taxable_money,
                                                        taxes)
      return tax, taxes if remaining_taxable_money.zero?

      [tax, taxes]
    end
  end

  def calculate_base_tax(taxes, tax_rate, taxable_income)
    calculated_rate = @ssf_amt.positive? ? 0 : (tax_rate / 100)
    tax = calculated_rate * taxable_income
    taxes[tax_rate.to_s] = { taxable_income => tax }
    [tax, taxes]
  end

  def calculate_tax_band(tax_rate, tax, limit, remaining_taxable_money, taxes)
    current_amount = [remaining_taxable_money, limit].min
    tax += (tax_rate / 100) * current_amount
    remaining_taxable_money -= current_amount
    taxes[tax_rate.to_s] = { current_amount => tax }
    [remaining_taxable_money, tax]
  end
end
