# Handles creation of customers
# Also handles indexing customers and showing customer detail
class Api::CustomersController < Api::ApiResource
  before_action :check_access!

  def index
    customers = User.where(role: 'customer')

    _render({
      customers: customers.as_json(
        only: [:id, :email]
      )
    })
  end

  def show
    raise "Missing id parameter" if params[:id].nil?

    customer = nil
    if params[:id] == 'current'
      customer = current_user
    else
      customer = User.where(id: params[:id]).first
    end

    raise RuntimeError, "Customer not found" if customer.nil?

    _render({
      customer: customer.as_json(
        only: [:id, :email],
        include: {
          payment_accounts: {
            only: [:id, :current_balance, :name, :account_type]
          }
        }
      )
    })
  end

  protected

  # Checks whether the user that is logged in has the rights
  # to access particular methods from this controller
  def check_access!
    deny_access! unless user_signed_in?
    if current_user.role == "teller"
      return true
    elsif current_user.role == "customer" && params[:id] == 'current'
      return true
    else
      deny_access!
    end
  end
end
