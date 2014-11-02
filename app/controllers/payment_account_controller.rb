class PaymentAccountController < ApplicationController
  before_action :authenticate_user!

  def view
    @accounts = current_user.payment_accounts
    render "view"
  end

  def money_op
    @account = current_user.payment_accounts.find(params[:id])
    if params[:op] == "credit"
      @account.current_balance += params[:ammount].to_f
    elsif params[:op] == "debit"
      @account.current_balance -= params[:ammount].to_f
    end
    @account.save
    redirect_to_view and return
  end

  def new
    @account = current_user.payment_account.new
    render "new"
  end

  def create
    @account = current_user.payment_account.create(account_params)
    if @account != nil
      # Go back to the account view
      redirect_to_view and return
    else
      @error_message = "There was a problem creating your account"
      render "new"
    end
  end

  def delete
    current_user.payment_accounts.find(params[:id]).delete
    redirect_to_view and return
  end

  def delete_all
    current_user.payment_accounts.each {|a| a.delete }

    # Go back to the account view
    redirect_to_view and return
  end


  protected ####################################################################

  def redirect_to_view
    redirect_to payment_accounts_view_path
  end

  def account_params
    params.require(:payment_account).permit(:name)
      .merge({user_id: current_user.id, current_balance: 0})
  end

  def credit_params
    
  end

  def debit_params

  end

end
