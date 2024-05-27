# SALARY TAX CALCULATOR FY080/081
The salary tax band for employees in nepal for the fiscal year 2080/81 is given as below. The application calculates the salary tax with the algorithm.

![TaxBand](https://lekhapro.com/wp-content/uploads/2023/06/lekha-pro-salary-slab.jpg)  
## ALGORITHM TO CALCULATE SALARY TAX
* Input **monthly_salary**, **insurance_amount**, **ssf_amount**, **epf_amount**, **cit_amount**, **bonus** and select the **marital_status**
* Calculate **annual_income** and get the **total_income** 
	* if **bonus** is present, `total_income = annual_income + bonus`
	* else `total_income=annual_income`
* Calculate the **base_taxable_income** which depends on the **marital_status** of the employee
	* if `marital_status == "married"`, then the

		`base_taxable_income = 6,00,000`
	* else, 
	`base_taxable_income = 5,00,000`
* Calculate the **taxable_income** based on **total_income** and other provided inputs

	 `taxable_income = total_income - insurance_amount - (ssf_amt/epf_amt + cit_amt)`
* Compare the **taxable_income** with **base_taxable_income**
	* if **taxable_income** is less than or equals to the **base_taxable_income**, i.e 

		`taxable_income <= base_taxable_income`, then calculate the tax with **tax_rate of 1%**

	* else, 
		calculate the **remaining_taxable_money** after each tax calculation with progressive tax bands until there is no remaining taxable money left for calculation of tax.
	  
		the first income difference is calculated as,

		`income_diff = taxable_income - base_taxable_income`
		
		while calculating the progressive tax initialize the **remaining_taxable_income** as,

		`remaining_taxable_money = income_diff`
		
		for each tax rates of **[10%, 20%, 30%, 36%, 39%]** with its limits like
		`10% tax_rate upto 2,00,000`, the **tax** and **remaining_taxable_money** are calculated
* After calculation, we return the **taxes**