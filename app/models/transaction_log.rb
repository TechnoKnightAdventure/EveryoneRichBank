# == Schema Information
#
# Table name: transaction_logs
#
#  id                 :integer          not null, primary key
#  payment_account_id :integer
#  actor_id           :integer
#  description        :string(255)
#  trans_type         :string(255)
#  amount             :decimal(, )
#  created_at         :datetime
#  updated_at         :datetime
#

class TransactionLog < ActiveRecord::Base
  belongs_to :payment_account
end
