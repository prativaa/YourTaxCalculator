# == Schema Information
#
# Table name: taxes
#
#  id               :integer          not null, primary key
#  monthly_income   :integer
#  insurance_amount :integer
#  ssf_amt          :integer
#  bonus            :integer
#  marital_status   :integer          default("unmarried")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Tax < ApplicationRecord
  enum marital_status: {
    unmarried: 0,
    married: 1
  }
end
