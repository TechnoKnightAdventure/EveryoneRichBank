class Api::PaymentAccountsController < Api::ApiResource
  skip_before_action :verify_authenticity_token
  before_filter :check_access!, except: [:index, :transfer, :create, :destroy]

  def index
    accounts = nil
    if current_user.role == 'customer'
      deny_access! unless params[:customer_id] == 'current'
      accounts = current_user.payment_accounts
    else
      accounts = PaymentAccount.where(user_id: params[:user_id])
    end

    _render({
      accounts: accounts.as_json(
        only: [:id, :current_balance, :name]
      )
    })
  end

  def transfer
    raise ArgumentError, "Amount is missing" if params[:amount].nil?
    amount = params[:amount].to_f
    raise ArgumentError, "Source is missing" if params[:fromId].nil?
    sourceAccount = PaymentAccount.find(params[:fromId]);
    raise ArgumentError, "Destination is missing" if params[:toId].nil?
    destinationAccount = PaymentAccount.find(params[:toId]);

    raise ArgumentError, "Insuffucient funds" if sourceAccount.current_balance < amount
    
    sourceAccount.current_balance -= amount
    destinationAccount.current_balance += amount

    sourceAccount.save
    destinationAccount.save

    _render({
      outcome: "positive"
    })
  end

  def all
    accounts = PaymentAccount.where(user_id: params[:user_id])

    _render({
      accounts: accounts
    })
  end

  def create
    raise ArgumentError, "Name missing" if params[:name].nil?
    customer = nil
    if current_user.role == "customer" && params[:customer_id] == 'current'
      customer = current_user
    elsif
      customer = User.find(params[:customer_id])
    else
      deny_access!
    end

    customer.payment_accounts.create(name: params[:name], current_balance: 0)

    _render({
      outcome: "positive"
    })
  end

  def destroy
    raise ArgumentError, "Id missing" if params[:id].nil?

    account = PaymentAccount.find(params[:id])

    account.delete

    _render({
      outcome: "positive"
    })
  end

  def show
    raise ArgumentError, 'Id is missing' if params[:id].nil?

    account = PaymentAccount.find(params[:id])

    _render({
      account: account.as_json(
        only: [:id, :current_balance, :name]
      )
    })
  end


  def credit_debit 
    raise ArgumentError, 'Id is missing' if params[:id].nil?
    raise ArgumentError, 'Operation is missing' if params[:operation].nil?
    raise ArgumentError, 'Amount is missing' if params[:amount].nil?

    account = PaymentAccount.find(params[:id])
    if params[:operation] == 'credit'
      account.current_balance += params[:amount].to_f
      account.save
    elsif params[:operation] == 'debit' 
      account.current_balance -= params[:amount].to_f
      account.save
    end
    
    _render({
      outcome: "positive"
    })
  end

  protected

  def check_access!
    deny_access! unless user_signed_in?
    deny_access! unless current_user.role == 'teller'
  end
end
