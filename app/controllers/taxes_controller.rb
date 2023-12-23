class TaxesController < ApplicationController
	def index;
	end

	def create
		@monthly_income = tax_params[:monthly_income].to_f
		@insurance_amount = tax_params[:insurance_amount].to_f
		@ssf_amt = tax_params[:ssf_amt].to_f
		@bonus = tax_params[:bonus].to_f

		@annual_income = @monthly_income*12
		@total_income = (@bonus > 0) ? (@annual_income+@bonus) : @annual_income
		base_taxable_income = (tax_params[:marital_status]=="married") ?  600000 : 500000
		if @total_income < 500000
			base_taxable_income = @total_income
			@taxable_income = base_taxable_income
		else
			@taxable_income = @total_income-@insurance_amount-@ssf_amt
			income_diff = @taxable_income-base_taxable_income
		end

		@result, @taxes = TaxCalculationService.new(@taxable_income, base_taxable_income, income_diff, @ssf_amt).execute
		puts "Result: #{@result}"
		puts "Taxes: #{@taxes}"
		# puts "No tax added for salary less than or equal 500000" if result==0
		respond_to do |format|
			unless @result==0 
				puts "Your monthly tax for monthly income of #{@monthly_income} with insurance deduction of #{@insurance_amount} is #{@result/12}"

				puts "Your tax for monthly income of #{@monthly_income} and annual income #{@total_income} with insurance deduction of #{@insurance_amount} is #{@result}"
				format.turbo_stream
			end
			format.html { redirect_to taxes_path }
		end
	end

	private

	def tax_params
		params.require(:tax).permit(:monthly_income, :insurance_amount, :marital_status, :ssf_amt, :bonus)
	end
end
