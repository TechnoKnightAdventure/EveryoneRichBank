class TellerController < ApplicationController
  before_action :check_user_is_teller!

  # get /teller/users
  def main
    # Just render the default template
  end

  def customer
    errors = []

    user = nil
    begin
      user = User.where(id: params[:id], role: 'customer').first
      raise "User with ID #{params[:id]} not found" if user.nil?
    rescue Exception => e
      errors.push e.message
    end

    json_message = nil
    if errors.empty? 
      json_message = {
        success: true,
        user: serialize_user(user)
      }
    else
      json_message = {
        success: false,
        message: "Query unsuccessfull",
        errors: errors
      }
    end
    
    respond_to do |format|
      format.json { render json: json_message }
    end
  end

  def list_customers
    users = User.where(role: 'customer').map do |user|
      serialize_user(user, trim_accounts: true)
    end

    respond_to do |format|
      format.json do
        render json: {
          success: true,
          users: users
        } 
      end 
    end
  end

  protected

  def serialize_user(user, trim_accounts: false)
    o = {
      id: user.id,
      email: user.email,
      balance: user.payment_accounts.inject(0) { |balance, a|
        if a.current_balance > 0
          balance += a.current_balance
        else
          0
        end
      }
    }
    if not trim_accounts
      o[:payment_accounts] = user.payment_accounts.map { |a|
        {
          id: a.id,
          name: a.name,
          balance: a.current_balance
        }
      }
    end
    return o
  end

  def check_user_is_teller!
    authenticate_user!
    if current_user.role != "teller"
      flash[:alert] = "You are not authorised to do this action"
      redirect_to root_path
    end
  end

end
