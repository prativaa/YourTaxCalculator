# frozen_string_literal: true

class TaxesController < ApplicationController # rubocop:disable Style/Documentation
  http_basic_authenticate_with name: 'pratibha', password: 'secret'
  def index; end

  def create
    initialize_objects
    calculate_taxable_income
    @result, @taxes = TaxCalculationService.new(@taxable_income, @base_taxable_income, @income_diff, @ssf_amt,
                                                @marital_status).execute
    # puts "No tax added for salary less than or equal 500000" if result==0
    respond_to do |format|
      flash[:notice] =
        "Your tax for monthly income of #{@monthly_income} and annual income #{@total_income} with insurance deduction of #{@insurance_amount} is #{@result}"
      format.turbo_stream
      # format.html { redirect_to taxes_path }
    end
  end

  private

  def initialize_objects
    @marital_status = tax_params[:marital_status]
    @monthly_income = tax_params[:monthly_income].to_f
    @insurance_amount = tax_params[:insurance_amount].to_f
    @ssf_amt = tax_params[:ssf_amt].to_f
    @bonus = tax_params[:bonus].to_f
  end

  def calculate_taxable_income
    @annual_income = @monthly_income * 12
    @total_income = @bonus.positive? ? (@annual_income + @bonus) : @annual_income
    @base_taxable_income = @marital_status == 'married' ? 600_000 : 500_000
    if @total_income < 500_000
      @base_taxable_income = @total_income
      @taxable_income = @base_taxable_income
    else
      @taxable_income = @total_income - @insurance_amount - @ssf_amt
      @income_diff = @taxable_income - @base_taxable_income
    end
  end

  def tax_params
    params.require(:tax).permit(:monthly_income, :insurance_amount, :marital_status, :ssf_amt, :bonus)
  end
end
