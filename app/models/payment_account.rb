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

class PaymentAccount < ActiveRecord::Base
  belongs_to :user
  has_many :transaction_log

  def credit(user, amount)
    self.current_balance += amount
    self.save

    self.transaction_log.create({
      actor_id: user.id,
      amount: amount,
      trans_type: "Credit",
      description: "A transaction was made"
    })
  end

  def debit(user, amount)
    # If there is not enough money in the account then throw the exception
    raise ArgumentError, "Insuffucient funds" if self.current_balance < amount
    self.current_balance -= amount
    self.save

    self.transaction_log.create({
      actor_id: user.id,
      amount: amount,
      trans_type: "Debit",
      description: "A transaction was made"
    })
  end

  def apply_penalty(amount)
    self.current_balance -= amount
    self.save

    # self.transaction_log.create({
    #   actor_id: 0,
    #   account_id: account.id,
    #   amount: amount,
    #   type: "Debit",
    #   description: "A transaction was made"
    # })
  end

end
