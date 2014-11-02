class PaymentAccountController < ApplicationController
  before_action :authenticate_user!

  def account
    @accounts = current_user.payment_accounts
    render "account"
  end

  def credit
    
  end

  def debit

  end

  def create
    current_user.payment_account.create(account_params)
    redirect_to '/payment_account/account' and return
  end

  def delete_all
    current_user.payment_accounts.each {|a| a.delete }
    redirect_to '/payment_account/account' and return
  end

  protected

  def account_params
    { user_id: current_user, current_balance: 0 }
  end

  def credit_params
    
  end

  def debit_params

  end

end
