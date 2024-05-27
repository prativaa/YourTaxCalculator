# frozen_string_literal: true

class TaxesController < ApplicationController # rubocop:disable Style/Documentation
  http_basic_authenticate_with name: 'pratibha', password: 'secret'
  def index; end

  def create
    tax = Tax.new(tax_params)
    if tax.valid?
      initialize_objects
      @total_income, @result, @taxes = TaxCalculationService.new(@monthly_income, @marital_status, @insurance_amount, @fund, @cit,
                                                                 @bonus).execute
      respond_to do |format|
        flash.now[:notice] =
          "Your tax for monthly income of #{@monthly_income} and annual income #{@total_income} with insurance deduction of #{@insurance_amount} is #{@result}"
        format.turbo_stream
      end
    else
      flash[:notice] = tax.errors.full_messages[0]
      redirect_to taxes_path
    end
  end

  private

  def initialize_objects
    @marital_status = tax_params[:marital_status]
    @monthly_income = tax_params[:monthly_income].to_f
    @insurance_amount = tax_params[:insurance_amount].to_f
    @fund = if tax_params[:ssf_amt].to_f.positive?
              tax_params[:ssf_amt].to_f
            else
              tax_params[:epf_amt].to_f
            end
    @cit = tax_params[:cit].to_f
    @bonus = tax_params[:bonus].to_f
  end

  def tax_params
    params.require(:tax).permit(:monthly_income, :insurance_amount, :marital_status, :ssf_amt, :epf_amt, :cit, :bonus)
  end
end
