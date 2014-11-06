class TellerController < ApplicationController
  before_action :check_user_is_teller!

  # get /teller/users
  def users
    users = User.where(role: 'customer').map do |user|
      {
        id: user.id,
        email: user.email,
        payment_accounts: user.payment_accounts.map { |a|
          {
            id: a.id,
            name: a.name,
            balance: a.current_balance
          }
        },
        balance: user.payment_accounts.inject(0) { |balance, a|
          if a.current_balance > 0
            balance += a.current_balance
          else
            0
          end
        }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: users }
    end
  end

  protected

  def check_user_is_teller!
    authenticate_user!
    if current_user.role != "teller"
      flash[:alert] = "You are not authorised to do this action"
      redirect_to root_path
    end
  end

end
