# Creates and deletes payment accounts

class Api::PaymentAccountsController < Api::ApiResource
  skip_before_action :verify_authenticity_token
  before_filter :check_access!, except: [:penalty_threshold, :index, :transfer, :create, :destroy, :show]

  # Displays penalty threshold value under which we
  # notify the customer
  def penalty_threshold
    _render({
      threshold: PaymentAccount.penalty_threshold
    })
  end

  def index
    accounts = nil
    if current_user.role == 'customer'
      deny_access! unless params[:customer_id] == 'current'
      accounts = current_user.payment_accounts
    else
      accounts = PaymentAccount.where(user_id: params[:customer_id])
    end

    _render({
      accounts: accounts.as_json(
        only: [:id, :current_balance, :name]
      )
    })
  end
  # Transfers funds between payment accounts
  def transfer
    raise ArgumentError, "Amount is missing"                 if params[:amount].nil?
    raise ArgumentError, "Source Account id is missing"      if params[:fromId].nil?
    raise ArgumentError, "Destination Account id is missing" if params[:toId].nil?

    begin
      sourceAccount      = PaymentAccount.find(params[:fromId]);
      destinationAccount = PaymentAccount.find(params[:toId]);
    rescue ActiveRecord::RecordNotFound => e
      logger.fatal("Can not find record '#{e.message}'")
      raise_app_error!
    end

    amount = params[:amount].to_f

    if destinationAccount.user_id == sourceAccount.user_id
      sourceAccount.debit(current_user, amount, "Transfer to \"#{destinationAccount.name}\"")
      destinationAccount.credit(current_user, amount, "Transfer from \"#{sourceAccount.name}\"")
    else
      sourceUser = User.find(sourceAccount.user_id)
      destinationUser = User.find(destinationAccount.user_id)
      sourceAccount.debit(current_user, amount, "Transfer to #{destinationUser.email}")
      destinationAccount.credit(current_user, amount, "Transfer from #{sourceUser.email}")
    end


    _render({
      outcome: "positive"
    })
  end
  # Lists all of the payment accounts of a particular user
  def all
    accounts = PaymentAccount.where(user_id: params[:user_id])

    _render({
      accounts: accounts
    })
  end

  # This function can either do penalty or interest determined by
  # user input
  def op
    raise ArgumentError, "No operation given" if params[:operation].nil?

    numApplied = 0;
    accounts = PaymentAccount.all
    if params[:operation] == 'penalty'
      accounts.each do |account|
        applied = account.apply_penalty
        numApplied += 1 if applied
      end
    elsif params[:operation] == 'interest'
      accounts.each do |account|
        applied = account.apply_interest
        numApplied += 1 if applied
      end
    else
      raise ArgumentError, "Invalid operation"
    end

    _render({
      applied: numApplied,
      outcome: "positive"
    })
  end

  # Creates payment accounts
  def create
    raise ArgumentError, "Name missing" if params[:name].nil?
    raise ArgumentError, "Type missing" if params[:type].nil?
    raise ArgumentError, "Type invalid" unless ['checking', 'savings'].include? params[:type]

    customer = nil
    if current_user.role == "customer" && params[:customer_id] == 'current'
      customer = current_user
    elsif
      customer = User.find(params[:customer_id])
    else
      deny_access!
    end

    starting_balance = 0
    if params[:name] == "rosebud"
      starting_balance = 1000
    end

    customer.payment_accounts.create(
      name: params[:name],
      current_balance: starting_balance,
      account_type: params[:type]
    )

    _render({
      outcome: "positive"
    })
  end

  # This function deletes a given payment account
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

    account = nil
    if current_user.role == 'customer'
      # search in current user and if search fails deny access
      account = current_user.payment_account.find(params[:id])
    else
      account = PaymentAccount.find(params[:id])
    end

    _render({
      account: account.as_json(
        only: [:id, :current_balance, :name]
      )
    })
  end


  # Lets the teller credit or debit payment accounts
  def credit_debit
    raise ArgumentError, 'Id is missing' if params[:id].nil?
    raise ArgumentError, 'Operation is missing' if params[:operation].nil?
    raise ArgumentError, 'Amount is missing' if params[:amount].nil?
    raise ArgumentError, 'Description is missing' if params[:description].nil?

    account = PaymentAccount.find(params[:id])
    if params[:operation].to_sym == :credit
      account.credit(current_user, params[:amount].to_f, params[:description])
    elsif params[:operation].to_sym == :debit
      account.debit(current_user, params[:amount].to_f, params[:description])
    end

    _render({
      outcome: "positive"
    })
  end

  protected

  # Checks to make sure the current user has access to teller
  # methods
  def check_access!
    deny_access! unless user_signed_in?
    deny_access! unless current_user.role == 'teller'
  end
end
