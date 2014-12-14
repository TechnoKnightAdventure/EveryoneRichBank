# deals with teller views

class TellersController < ApplicationController
  before_action :check_user_is_teller!

  def index
  end

  protected
 # checks to see if a current user is a teller
  def check_user_is_teller!
    authenticate_user!
    if current_user.role != "teller"
      flash[:alert] = "You are not authorised to do this action"
      redirect_to root_path
    end
  end
end
