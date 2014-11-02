# == Schema Information
#
# Table name: payment_accounts
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  current_balance :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#  name            :string(255)
#

require 'test_helper'

class PaymentAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
