class TaxCalculationService
	def initialize(taxable_income, base_taxable_income, income_diff, ssf_amt, marital_status)
		@taxable_income = taxable_income
		@base_taxable_income = base_taxable_income
		@income_diff = income_diff
		@ssf_amt = ssf_amt
		@marital_status = marital_status
	end

	def execute
		self.calculate_tax
	end

	private

	def calculate_tax
		taxes = {}
		puts "Taxable income: #{@taxable_income}"
  	puts "Base taxable income: #{@base_taxable_income}"

		@ssf_amt>0 ? (tax = 0) : (tax = (1.0/100)*@base_taxable_income)
		taxes["0"] = {@base_taxable_income => tax}
		puts "1% tax upto #{@base_taxable_income}: #{tax}"
		if(@taxable_income <= @base_taxable_income )
			@ssf_amt>0 ? (tax = 0) : (tax += (1.0/100)*@taxable_income)
			tax
			taxes["1"] = {@base_taxable_income => tax}
		elsif (@income_diff > 0)
			(@income_diff >= 200000 ) ? (current_amount = 200000) : (current_amount = @income_diff)
			tax_rate=10.0
			remaining_taxable_money, tax = calculate_remaining_tax(@income_diff, current_amount, tax_rate, tax)
			taxes["10"] = {current_amount => tax}
			return tax, taxes if remaining_taxable_money==0
			if remaining_taxable_money > 0
				(remaining_taxable_money >= 300000 ) ? (current_amount = 300000) : (current_amount = remaining_taxable_money)
				tax_rate=20.0

				remaining_taxable_money, tax = calculate_remaining_tax(remaining_taxable_money, current_amount, tax_rate, tax)
				taxes["20"] = {current_amount => tax}
				return tax, taxes if remaining_taxable_money==0

				if remaining_taxable_money > 0
					if @marital_status == "unmarried"
						(remaining_taxable_money >= 1000000 ) ? (current_amount = 1000000) : (current_amount = remaining_taxable_money)
					else
						(remaining_taxable_money >= 900000 ) ? (current_amount = 900000) : (current_amount = remaining_taxable_money)
					end
					tax_rate=30.0

					remaining_taxable_money, tax = calculate_remaining_tax(remaining_taxable_money, current_amount, tax_rate, tax)
					taxes["30"] = {current_amount => tax}
					return tax, taxes if remaining_taxable_money==0

					if remaining_taxable_money > 0
						(remaining_taxable_money >= 3000000 ) ? (current_amount = 3000000) : (current_amount = remaining_taxable_money)
						tax_rate=36.0

						remaining_taxable_money, tax = calculate_remaining_tax(remaining_taxable_money, current_amount, tax_rate, tax)
						taxes["36"] = { current_amount => tax}
						return tax, taxes if remaining_taxable_money==0
						if remaining_taxable_money > 0
							current_amount = remaining_taxable_money if (remaining_taxable_money >= 5000000)
							tax_rate=39.0
	
							remaining_taxable_money, tax = calculate_remaining_tax(remaining_taxable_money, current_amount, tax_rate, tax)
							taxes["39"] = { current_amount => tax}
							return tax, taxes
						end
					end
				end
			end
		end

	end

	def calculate_remaining_tax(remaining_taxable_money, current_amount, tax_rate, tax)
		tax += (tax_rate/100)*current_amount
		remaining_taxable_money -= current_amount
		return remaining_taxable_money, tax
	end
	
end