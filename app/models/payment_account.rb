# == Schema Information
#
# Table name: payment_accounts
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  current_balance :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#

class PaymentAccount < ActiveRecord::Base
  belongs_to :user
end
