# Lists all of the transactions for an existing payment account
class Api::TransactionsController < Api::ApiResource

  def index
    raise ArgumentError, "Payment Account id is missng" if params[:payment_account_id].nil?

    begin
      account = nil
      if current_user.role == 'customer'
        customer     = current_user
        account      = customer.payment_account.find(params[:payment_account_id])
      elsif
        account      = PaymentAccount.find(params[:payment_account_id])
      end

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
