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

  @@penalty_threshold = 100
  @@penalty_amount    = 25

  @@interest_threshold_low  = 1000
  @@interest_threshold_high = 2000

  def credit(user, amount, description)
    self.current_balance += amount
    self.save

    self.transaction_log.create({
      actor_id: user.id,
      amount: amount,
      trans_type: "Credit",
      description: description
    })
  end

  def debit(user, amount, description)
    # If there is not enough money in the account then throw the exception
    raise ArgumentError, "Insuffucient funds" if self.current_balance < amount
    self.current_balance -= amount
    self.save

    self.transaction_log.create({
      actor_id: user.id,
      amount: (-amount),
      trans_type: "Debit",
      description: description
    })
  end

  def get_current_average_balance()
    beginningOfMonth = DateTime.new(Date.today.year, Date.today.month, 1)
    transactions = self.transaction_log.where("created_at > ?", beginningOfMonth)
    
    i = transactions.size - 1
    currentDay = Date.today.day + 1
    daysEndBalance = self.current_balance
    avgAccountBalance = 0
    
    while i >= 0 and currentDay > 1 do
      if currentDay != transactions[i].created_at.day then
        currentDay -= 1
        avgAccountBalance += daysEndBalance
        next
      end

      if transactions[i].trans_type == "Debit" then
        daysEndBalance -= transactions[i].amount
      else 
        daysEndBalance += transactions[i].amount
      end

      i -= 1
    end

    while currentDay > 1 do
      avgAccountBalance += daysEndBalance
      currentDay -= 1
    end

    necessaryFunds = ((@@penalty_threshold * Time.days_in_month(Date.today.month, Date.today.year)) - avgAccountBalance) / (Time.days_in_month(Date.today.month, Date.today.year) - Date.today.day)
    avgAccountBalance /= Date.today.day

    return {
      avg_balance: avgAccountBalance,
      necessary_funds: necessaryFunds
    }
  end

  def apply_penalty()
    if not self.current_balance.nil? and self.current_balance < @@penalty_threshold
      self.current_balance -= @@penalty_amount

      self.transaction_log.create({
        actor_id: 0,
        amount: (-@@penalty_amount),
        trans_type: "Penalty",
        description: "A penalty was applied because account was under #{@@penalty_threshold}"
      });

      self.save
      return true
    end

    return false
  end

  def apply_interest(amount)
    # self.current_balance -= @penalty_amount
    #
    # self.transaction_log.create({
    #   actor_id: 0,
    #   amount: (-@penalty_amount),
    #   type: "Debit",
    #   description: "A penalty was applied because account was under #{@penalty_threshold}"
    # });
    #
    # self.save

    return false
  end

end
