class TaxesController < ApplicationController
	def index
	end

	def create
		monthly_income = params[:monthly_income]
		insurance_amount = params[:insurance_amount]
		ssf_amt = params[:ssf_amt]
		bonus = params[:bonus]

		annual_income = monthly_income*12
		total_income = (bonus>0) ? (annual_income+bonus) : annual_income

		base_taxable_income = (params[:marital_status]=="married") ?  600000 : 500000

		taxable_income = total_income-insurance_amount-ssf_amt
		income_diff = taxable_income-base_taxable_income

		result = TaxCalculationService.new(taxable_income, base_taxable_income, income_diff, ssf_amt).execute
		puts "No tax added for salary less than or equal 500000" if result==0
		unless result==0 
			puts "Your monthly tax for monthly income of #{monthly_income} with insurance deduction of #{insurance_amount} is #{result/12}"

			puts "Your tax for monthly income of #{monthly_income} and annual income #{total_income} with insurance deduction of #{insurance_amount} is #{result}"
		end
	end

	private

	def tax_params
		params.require(:tax).permit(:monthly_income, :insurance_amount, :marital_status, :ssf_amt, :bonus)
	end
end
