# frozen_string_literal: true

class CreateTaxes < ActiveRecord::Migration[7.1]
  def change
    create_table :taxes do |t|
      t.integer :monthly_income, precision: 8, scale: 2
      t.integer :insurance_amount, precision: 8, scale: 2
      t.integer :ssf_amt, precision: 8, scale: 2
      t.integer :cit, precision: 8, scale: 2
      t.integer :bonus, precision: 8, scale: 2
      t.integer :marital_status, default: 0
      t.timestamps
    end
  end
end
