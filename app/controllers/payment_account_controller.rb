class PaymentAccountController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_user_is_teller!, only: [:credit_debit, :new, :create, :delete, :delete_all]

  def view
    @accounts = current_user.payment_accounts
    render "view"
  end

  def credit_debit
    errors = []
    errors.push "Account ID is missing" unless params[:id].present?
    errors.push "Operation type is missing" unless params[:operation].present?
    errors.push "Invalid operation" unless params[:operation].in? ['credit', 'debit']
  
    account = nil

    if errors.empty?
      begin
        account = PaymentAccount.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        errors.push "Account with id #{params[:id]} not found" if user.nil?
      end
    end

    if params[:operation].to_sym == :credit
      account.current_balance += params[:ammount].to_f
    elsif params[:operation].tosym == :debit
      account.current_balance -= params[:ammount].to_f
    end

    account.save

    json_message = nil
    if errors.empty?
      json_message = {
        success: true,
        message: "Operation completed successfully"
      }
    else 
      json_message = {
        success: false,
        message: "Threre were #{errors.size} errors that prevented the operation from completing",
        errors: errors
      }
    end

    respond_to do |format|
      format.json { render json: json_message }
    end
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

  def check_user_is_teller!
    if current_user.role != "teller"
      flash[:alert] = "You are not authorised to do this action"
      redirect_to_view
    end
  end

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
