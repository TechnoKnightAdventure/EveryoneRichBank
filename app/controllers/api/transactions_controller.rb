class Api::TransactionsController < Api::ApiResource

  def index
    raise ArgumentError, "Payment Account id is missng" if params[:payment_account_id].nil?

    begin
      if current_user.role == 'customer' 
        customer = current_user
      elsif 
        customer = User.find(params[:customer_id])
      end

      account      = customer.payment_account.find(params[:payment_account_id])
      transactions = account.transaction_log.all
    rescue Exception => e
      logger.fatal("Can not get transaction '#{e.message}'")
      raise_app_error!
    end

    _render({
      transactions: transactions.as_json(
        only: [:amount, :description, :trans_type, :updated_at]
      )
    })
  end
end
