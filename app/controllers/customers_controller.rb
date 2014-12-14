# Deals with all of the customer views
class CustomersController < ApplicationController
  before_action :check_user_is_customer!

  def index
  end

  protected

# checks to make sure a user is a customer
  def check_user_is_customer!
    authenticate_user!
    unless current_user.role == "customer"
      flash[:alert] = "You are not authorised to do this action"
      redirect_to root_path
    end
  end
end
